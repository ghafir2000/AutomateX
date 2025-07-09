<?php

namespace App\Events;

use App\Models\Barcode;
use Illuminate\Broadcasting\Channel;
use Illuminate\Queue\SerializesModels;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class BarcodeEvent implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    protected Barcode $Barcode;
    protected $userId;
    protected $isUpdate;

    /**
     * Create a new event instance.
     */
    public function __construct(Barcode $Barcode, int $userId, bool $isUpdate = false)
    {
        $this->Barcode = $Barcode;
        $this->userId = $userId;
        $this->isUpdate = $isUpdate;
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
        return 'barcode-event'; // Keep this consistent with Flutter
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
            'barcode' => $this->Barcode,
            'isUpdate' => $this->isUpdate
        ];
    }
}

