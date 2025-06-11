<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class BarcodeIndexEvent implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    protected Collection $barcodes;
    protected $userId;

    /**
     * Create a new event instance.
     */
    public function __construct(Barcode $barcodes, int $userId)
    {
        $this->barcodes = $barcodes;
        $this->userId = $userId;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return array<int, \Illuminate\Broadcasting\Channel>
     */
    public function broadcastOn(): array
    {
        return [new PrivateChannel("user.{$this->userId}.barcodes")];
    }
    public function broadcastAs(): string
    {
        return 'barcodes-event'; // Keep this consistent with Flutter
    }

    /**
     * Get the data to broadcast.
     *
     * @return array
     */
    public function broadcastWith(): array
    {
        // Ensure the data structure matches what Flutter expects for parsing
        return [
            'barcodes' => $this->barcodes->map(function($barcode) {
                return [
                    'id' => $barcode->id,
                    'barcode' => $barcode->barcode, // Use 'barcode' field from your migration
                    // You can add other relevant barcode fields here
                ];
            })->toArray(),
        ];
    }
}

