{{-- resources/views/web/barcodes/index.blade.php --}}

@extends('app')

@section('title', __('Barcodes List'))

{{-- @push('styles')
    <style>
        /* ALL YOUR PREVIOUS STYLES HAVE BEEN MOVED TO app.css/app.scss */
    </style>
@endpush --}}
{{-- The @push('styles') block can be removed if all styles are global now --}}


@section('content')
<div class="container mt-4 barcode-page-container"> {{-- This class is now styled by app.css/app.scss --}}
    <div class="text-center mb-4">
        {{-- I see you changed the logo name, ensure this exists: public/images/AutomateX.png --}}
        <img src="{{ asset('images/AutomateX.png') }}" alt="@lang('Company Logo')"
             style="display: block; margin-left: auto; margin-right: auto; width: 400px; max-height: 200px; object-fit: contain;">
    </div>

    <div class="card mx-auto" style="width: 90%;">
        <div class="card-header text-center bg-info">
            <h2>@lang('Barcode List')</h2>
        </div>
        <div class="card-body">
            @php
                $barcodeDisplayImages = [asset('images/A.png'), asset('images/B.png'), asset('images/C.png')];
                $page = $barcodes instanceof \Illuminate\Pagination\LengthAwarePaginator ? $barcodes->currentPage() : 1;
                $perPage = $barcodes instanceof \Illuminate\Pagination\LengthAwarePaginator ? $barcodes->perPage() : count($barcodeDisplayImages);
                $initialImageIndex = ($barcodes && $barcodes->count() > 0) ? (($page - 1) * $perPage) : 0;
            @endphp
            @if($barcodes && $barcodes->count() > 0)
                <div class="table-responsive">
                    <table class="table table-bordered align-middle" id="barcodes-table">
                        <thead class="table-dark">
                            <tr>
                                <th class="text-center">@lang('Barcode Image')</th>
                                <th>@lang('Value / Code')</th>
                                <th>@lang('Associated Part')</th>
                                <th class="text-center">@lang('Actions')</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($barcodes as $index => $item)
                            @php
                                $currentDisplayImage = $barcodeDisplayImages[($initialImageIndex + $loop->index) % count($barcodeDisplayImages)];
                            @endphp
                            <tr>
                                <td class="text-center">
                                    <img src="{{ $currentDisplayImage }}"
                                         alt="@lang('Barcode for') {{ $item->barcode ?? 'N/A' }}"
                                         style="max-height: 60px; display: block; margin: auto; background-color: white; padding: 5px;">
                                </td>
                                <td>{{ $item->barcode ?? __('N/A') }}</td>
                                <td>
                                @if (str_ends_with($currentDisplayImage, 'A.png'))
                                    @lang('Part A')
                                @elseif (str_ends_with($currentDisplayImage, 'B.png'))
                                    @lang('Part B')
                                @elseif (str_ends_with($currentDisplayImage, 'C.png'))
                                    @lang('Part C')
                                @endif
                                </td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-sm btn-secondary" onclick="printBarcodeImage('{{ $currentDisplayImage }}')" title="@lang('Print Displayed Image')">
                                        <i class="fas fa-print"></i> {{-- Font Awesome icon --}}
                                    </button>
                                </td>
                            </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
                @if ($barcodes instanceof \Illuminate\Pagination\LengthAwarePaginator)
                    <div class="d-flex justify-content-center mt-3">
                        {{-- Bootstrap pagination styling will apply automatically --}}
                        {{ $barcodes->links() }}
                    </div>
                @endif
            @else
                <p class="text-center">@lang('No barcodes found.')</p>
            @endif
        </div>
        <div class="card-footer text-end">
            <a href="{{ url()->previous() }}" class="btn btn-secondary">@lang('Go Back')</a>
        </div>
    </div>
</div>
@endsection

@push('scripts')
{{-- If Bootstrap JS is not part of app.js and needed for this page specifically --}}
{{-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script> --}}


@push('scripts')
<script>
    // Ensure this script block runs after app.js (which initializes Echo)

    // Helper function for logging with context
    function logEcho(message, data = null) {
        console.log(`[Barcode Page Echo] ${message}`, data || '');
    }

    // Initialize these for the Echo callback, defined outside to be accessible
    let barcodeImagePaths = [];
    let nextDynamicImageIndex = 0;

    @php
        // Prepare these for JS embedding
        $jsBarcodeDisplayImages = [asset('images/A.png'), asset('images/B.png'), asset('images/C.png')];
        $jsInitialImageIndex = 0;
        $jsTotalInitialItems = 0;
        if ($barcodes && $barcodes->count() > 0) {
            $page = $barcodes instanceof \Illuminate\Pagination\LengthAwarePaginator ? $barcodes->currentPage() : 1;
            $perPage = $barcodes instanceof \Illuminate\Pagination\LengthAwarePaginator ? $barcodes->perPage() : count($jsBarcodeDisplayImages); // or $barcodes->count()
            $jsInitialImageIndex = ($page - 1) * $perPage;
            $jsTotalInitialItems = $barcodes->count();
        }
    @endphp

    barcodeImagePaths = @json($jsBarcodeDisplayImages);
    nextDynamicImageIndex = ({{ $jsInitialImageIndex }} + {{ $jsTotalInitialItems }}) % barcodeImagePaths.length;
    logEcho('Initial image paths and index set.', { paths: barcodeImagePaths, nextIndex: nextDynamicImageIndex });


    @auth
        const currentUserId = {{ auth()->id() }};
        logEcho(`User authenticated with ID: ${currentUserId}. Attempting to listen on private channel.`);

        // Wait for DOM content to be fully loaded, especially if Echo init is also deferred.
        // More robust: ensure Echo is truly ready. A small delay or custom event can help.
        // For now, assuming app.js (with Echo init) loads and executes before this pushed script.
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof window.Echo !== 'undefined') {
                logEcho('Echo object found. Subscribing to private channel.');
                try {
                    window.Echo.private(`user.${currentUserId}.barcodes`)
                        .listen('.barcodes-event', (e) => {
                            logEcho('BarcodesEvent received:', e);
                            const barcodesTableBody = document.querySelector('#barcodes-table tbody');
                            if (!barcodesTableBody) {
                                console.error('[Barcode Page Echo] Barcodes table body not found!');
                                return;
                            }
                            if (!e.barcode) {
                                console.error('[Barcode Page Echo] Event received but "e.barcode" is missing or undefined.', e);
                                return;
                            }

                            const newRow = document.createElement('tr');
                            const imageToUse = barcodeImagePaths[nextDynamicImageIndex];
                            nextDynamicImageIndex = (nextDynamicImageIndex + 1) % barcodeImagePaths.length;

                            const barcodeValue = e.barcode.value || e.barcode.barcode || 'N/A';
                            const productName = e.barcode.product_name || 'N/A';

                            newRow.innerHTML = `
                                <td class="text-center">
                                    <img src="${imageToUse}"
                                         alt="Barcode for ${barcodeValue}"
                                         style="max-height: 60px; display: block; margin: auto; background-color: white; padding: 5px;">
                                </td>
                                <td>${barcodeValue}</td>
                                <td>${productName}</td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-sm btn-secondary" onclick="printBarcodeImage('${imageToUse}')" title="Print Displayed Image">
                                        <i class="fas fa-print"></i>
                                    </button>
                                </td>
                            `;
                            barcodesTableBody.prepend(newRow);
                            logEcho('New barcode row prepended to table.');
                        })
                        .error((error) => { // Listen for subscription errors
                            console.error('[Barcode Page Echo] Error subscribing to private channel:', error);
                        });

                    // You can also listen for general connection state changes on Echo.connector.pusher
                    if (window.Echo.connector && window.Echo.connector.pusher) {
                        const pusherInstance = window.Echo.connector.pusher;
                        pusherInstance.connection.bind('state_change', function(states) {
                            logEcho('Pusher connection state changed:', states);
                            // states.current will be 'connected', 'connecting', 'unavailable', 'failed', 'disconnected'
                            if (states.current === 'connected') {
                                logEcho('Pusher connected successfully via Echo connector!');
                            }
                        });
                        pusherInstance.connection.bind('error', function(err) {
                            console.error('[Barcode Page Echo] Pusher connection error via Echo connector:', err);
                        });
                    }


                } catch (error) {
                    console.error('[Barcode Page Echo] Error setting up Echo listener:', error);
                }
            } else {
                console.warn('[Barcode Page Echo] Laravel Echo is not defined when DOMContentLoaded. Real-time updates may not work.');
            }
        });
    @else
        logEcho('User not authenticated. Real-time barcode updates disabled.');
    @endauth

    // Print function specific to this page
    function printBarcodeImage(imageUrl) {
        if (!imageUrl) {
            alert("@lang('Barcode image URL is not available.')");
            return;
        }
        const printWindow = window.open('', '_blank', 'height=400,width=600');
        printWindow.document.write('<html><head><title>@lang('Print Barcode')</title>');
        printWindow.document.write('<style>body { margin: 20px; text-align: center; } img { max-width: 100%; max-height: 250px; display: block; margin: auto; }</style>');
        printWindow.document.write('</head><body>');
        printWindow.document.write('<h3>@lang('Scan Barcode')</h3>');
        printWindow.document.write(`<img src="${imageUrl}" onload="window.print(); setTimeout(function() { window.close(); }, 200);" onerror="alert('@lang('Could not load barcode image for printing.')'); window.close();">`);
        printWindow.document.write('</body></html>');
        printWindow.document.close();
    }
</script>
@endpush