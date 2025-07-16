<?php

namespace App\Console\Commands;

use App\Models\Barcode;
use App\Events\BarcodeEvent; // Your existing event
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;
use PhpMqtt\Client\Facades\MQTT;

class MqttListener extends Command
{
    protected $signature = 'mqtt:listen';
    protected $description = 'Listens for MQTT messages from IoT QR Scanners';

    public function handle()
    {
        $this->info("Starting MQTT Listener...");

        $mqtt = MQTT::connection();
        $topic = 'esp-cam/scan/data'; // The topic the ESP will publish to

        $mqtt->subscribe($topic, function (string $topic, string $message) {
            $this->info("Received QR data on topic [{$topic}]: {$message}");
            Log::info("MQTT Message Received: " . $message);

            $data = json_decode($message, true);

            // --- DATA VALIDATION ---
            if (!$data || !isset($data['qrData'])) {
                Log::warning('Received malformed MQTT message.');
                return; // Ignore malformed message
            }

            $qrCodeValue = $data['qrData'];

            // --- REUSE YOUR EXISTING LOGIC ---
            // We'll mimic what your BarcodeController does.

            // Find if the barcode already exists
            $barcode = Barcode::where('value', $qrCodeValue)->first();
            
            // For a private channel, we need a user. For this IoT context,
            // we'll hardcode a "system" user or a specific user ID.
            // IMPORTANT: Change '1' to the ID of the user you want to broadcast to.
            $targetUserId = 1; 

            if ($barcode) {
                // IT'S AN UPDATE
                $this->info("Barcode [{$qrCodeValue}] exists. Processing as UPDATE.");
                $barcode->touch(); // Just update the updated_at timestamp
                $isUpdate = true;
                event(new BarcodeEvent($barcode, $targetUserId, $isUpdate));
            } else {
                // IT'S A NEW ENTRY
                $this->info("Barcode [{$qrCodeValue}] is new. Processing as CREATE.");
                try {
                    $newBarcode = Barcode::create([
                        'value' => $qrCodeValue,
                        // Add any other required fields with default values
                        // 'part_id' => 1, // Example
                    ]);
                    $isUpdate = false;
                    event(new BarcodeEvent($newBarcode, $targetUserId, $isUpdate));
                } catch (\Exception $e) {
                    Log::error("Failed to create barcode from MQTT: " . $e->getMessage());
                }
            }

        }, 0); // QoS level 0 is fine for this

        $mqtt->loop(true);
    }
}