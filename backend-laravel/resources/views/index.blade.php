{{-- resources/views/web/barcodes/index.blade.php --}}

@extends('app')

@section('title', __('Barcodes List'))

@section('content')
<div class="container mt-4 barcode-page-container">
    <div class="text-center mb-4">
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
                                <th>@lang('Associated Table')</th> {{-- New Column Header --}}
                                <th>@lang('Start Time')</th>
                                <th>@lang('Current Time')</th>
                                <th class="text-center">@lang('Actions')</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($barcodes as $index => $item)
                            @php
                                $currentDisplayImage = $barcodeDisplayImages[($initialImageIndex + $loop->index) % count($barcodeDisplayImages)];
                                $partNameFromImage = '';
                                if (str_ends_with($currentDisplayImage, 'A.png')) {
                                    $partNameFromImage = __('Part A');
                                } elseif (str_ends_with($currentDisplayImage, 'B.png')) {
                                    $partNameFromImage = __('Part B');
                                } elseif (str_ends_with($currentDisplayImage, 'C.png')) {
                                    $partNameFromImage = __('Part C');
                                }
                            @endphp
                            {{-- Add data-barcode-id attribute to the row for easier targeting --}}
                            <tr data-barcode-id="{{ $item->id }}">
                                <td class="text-center">
                                    <img src="{{ $currentDisplayImage }}"
                                         alt="@lang('Barcode for') {{ $item->barcode ?? 'N/A' }}"
                                         style="max-height: 60px; display: block; margin: auto; background-color: white; padding: 5px;">
                                </td>
                                <td>{{ $item->value ?? __('N/A') }}</td>
                                <td>
                                    {{-- Use actual part name if available, otherwise fallback to image-based name --}}
                                    {{ $item->part->name ?? $partNameFromImage }}
                                </td>
                                <td>
                                    {{-- Assuming Barcode model has a 'table' relationship --}}
                                    {{ $item->table->name ?? ($item->table_id ?? __('N/A')) }} {{-- New Column Data --}}
                                </td>
                                <td>{{ $item->created_at ? (new DateTime($item->created_at))->format('d/m/Y, g:i:s A') : __('N/A') }}</td>
                                <td>{{ $item->updated_at ? (new DateTime($item->updated_at))->format('d/m/Y, g:i:s A') : __('N/A') }}</td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-sm btn-secondary" onclick="printBarcodeImage('{{ $currentDisplayImage }}')" title="@lang('Print Displayed Image')">
                                        <i class="fas fa-print"></i>
                                    </button>
                                </td>
                            </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
                @if ($barcodes instanceof \Illuminate\Pagination\LengthAwarePaginator)
                    <div class="d-flex justify-content-center mt-3">
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
<script>
    function logEcho(message, data = null) {
        console.log(`[Barcode Page Echo] ${message}`, data || '');
    }

    let barcodeImagePaths = [];
    let nextDynamicImageIndex = 0;

    @php
        $jsBarcodeDisplayImages = [asset('images/A.png'), asset('images/B.png'), asset('images/C.png')];
        $jsInitialImageIndex = 0;
        $jsTotalInitialItems = 0;
        if ($barcodes && $barcodes->count() > 0) {
            $page = $barcodes instanceof \Illuminate\Pagination\LengthAwarePaginator ? $barcodes->currentPage() : 1;
            $perPage = $barcodes instanceof \Illuminate\Pagination\LengthAwarePaginator ? $barcodes->perPage() : count($jsBarcodeDisplayImages);
            $jsInitialImageIndex = ($page - 1) * $perPage;
            $jsTotalInitialItems = $barcodes->count();
        }
    @endphp

    barcodeImagePaths = @json($jsBarcodeDisplayImages);
    nextDynamicImageIndex = ({{ $jsInitialImageIndex }} + {{ $jsTotalInitialItems }}) % barcodeImagePaths.length;
    logEcho('Initial image paths and index set.', { paths: barcodeImagePaths, nextIndex: nextDynamicImageIndex });

    // Helper to format date similar to PHP's 'd/m/Y, g:i:s A'
    function formatJsDateTime(dateString) {
        if (!dateString) return 'N/A';
        try {
            const date = new Date(dateString);
            const day = String(date.getDate()).padStart(2, '0');
            const month = String(date.getMonth() + 1).padStart(2, '0'); // Months are 0-indexed
            const year = date.getFullYear();
            
            let hours = date.getHours();
            const minutes = String(date.getMinutes()).padStart(2, '0');
            const seconds = String(date.getSeconds()).padStart(2, '0');
            const ampm = hours >= 12 ? 'PM' : 'AM';
            hours = hours % 12;
            hours = hours ? hours : 12; // the hour '0' should be '12'
            const strTime = String(hours).padStart(2, '0') + ':' + minutes + ':' + seconds + ' ' + ampm;

            return `${day}/${month}/${year}, ${strTime}`;
        } catch (e) {
            return 'Invalid Date';
        }
    }


    @auth
        const currentUserId = {{ auth()->id() }};
        logEcho(`User authenticated with ID: ${currentUserId}. Attempting to listen on private channel.`);

        document.addEventListener('DOMContentLoaded', function() {
            if (typeof window.Echo !== 'undefined') {
                logEcho('Echo object found. Subscribing to private channel.');
                try {
                    window.Echo.private(`user.${currentUserId}.barcodes`)
                        .listen('.barcode-event', (e) => {
                            logEcho('BarcodesEvent received:', e);
                            const barcodesTableBody = document.querySelector('#barcodes-table tbody');
                            if (!barcodesTableBody) {
                                console.error('[Barcode Page Echo] Barcodes table body not found!');
                                return;
                            }
                            if (!e.barcode || !e.barcode.id) { // Ensure barcode and its ID are present
                                console.error('[Barcode Page Echo] Event received but "e.barcode" or "e.barcode.id" is missing or undefined.', e);
                                return;
                            }

                            const barcodeValue = e.barcode.barcode || e.barcode.value || 'N/A'; // Use barcode.barcode first as per migration
                            const imageToUse = barcodeImagePaths[nextDynamicImageIndex]; // Get image before potential return in update
                            const associatedPartNameFromImage =
                                imageToUse.endsWith('A.png') ? '@lang('Part A')' :
                                imageToUse.endsWith('B.png') ? '@lang('Part B')' :
                                imageToUse.endsWith('C.png') ? '@lang('Part C')' :
                                __('N/A');

                            if (e.isUpdate === true) {
                                logEcho('Processing as UPDATE event for barcode ID:', e.barcode.id);
                                const existingRow = barcodesTableBody.querySelector(`tr[data-barcode-id="${e.barcode.id}"]`);
                                if (existingRow) {
                                    logEcho('Found existing row to update:', existingRow);
                                    // Update columns. Adjust nth-child if column order changes.
                                    // 1: Image (usually not updated this way, but if needed, handle image src)
                                    // existingRow.querySelector('td:nth-child(1) img').src = newImageSource;
                                    existingRow.querySelector('td:nth-child(2)').textContent = barcodeValue;
                                    existingRow.querySelector('td:nth-child(3)').textContent = e.barcode.part_name || associatedPartNameFromImage; // Prefer actual part name if sent
                                    existingRow.querySelector('td:nth-child(4)').textContent = e.barcode.table_name || e.barcode.table_id || 'N/A'; // Prefer actual table name if sent
                                    existingRow.querySelector('td:nth-child(5)').textContent = formatJsDateTime(e.barcode.created_at);
                                    existingRow.querySelector('td:nth-child(6)').textContent = formatJsDateTime(e.barcode.updated_at);
                                    // 7: Actions (button - usually not updated dynamically unless its attributes change)
                                    logEcho('Row updated successfully.');
                                    return; // Stop further processing for this event
                                } else {
                                    logEcho('isUpdate was true, but no existing row found for ID. Will add as new.', e.barcode.id);
                                    // Fall through to add as new if row not found, or handle as an error
                                }
                            }

                            // If not an update, or if update target not found, add as new row
                            logEcho('Processing as NEW entry or fallback from failed update.');
                            const newRow = document.createElement('tr');
                            newRow.setAttribute('data-barcode-id', e.barcode.id); // Set ID for future updates

                            nextDynamicImageIndex = (nextDynamicImageIndex + 1) % barcodeImagePaths.length;

                            newRow.innerHTML = `
                                <td class="text-center">
                                    <img src="${imageToUse}"
                                         alt="Barcode for ${barcodeValue}"
                                         style="max-height: 60px; display: block; margin: auto; background-color: white; padding: 5px;">
                                </td>
                                <td>${barcodeValue}</td>
                                <td>${e.barcode.part_name || associatedPartNameFromImage}</td> {{-- Prefer actual part name --}}
                                <td>${e.barcode.table_name || e.barcode.table_id || 'N/A'}</td> {{-- New Table Data Cell --}}
                                <td>${formatJsDateTime(e.barcode.created_at)}</td>
                                <td>${formatJsDateTime(e.barcode.updated_at)}</td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-sm btn-secondary" onclick="printBarcodeImage('${imageToUse}')" title="@lang('Print Displayed Image')">
                                        <i class="fas fa-print"></i>
                                    </button>
                                </td>
                            `;
                            barcodesTableBody.prepend(newRow); // Add to the top
                            logEcho('New barcode row prepended to table.');
                        })
                        .error((error) => {
                            console.error('[Barcode Page Echo] Error subscribing to private channel:', error);
                        });

                    if (window.Echo.connector && window.Echo.connector.pusher) {
                        const pusherInstance = window.Echo.connector.pusher;
                        pusherInstance.connection.bind('state_change', function(states) {
                            logEcho('Pusher connection state changed:', states);
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

    function printBarcodeImage(imageUrl) {
        // ... (your existing print function)
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