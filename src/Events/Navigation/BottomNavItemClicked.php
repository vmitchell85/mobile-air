<?php

namespace Native\Mobile\Events\Navigation;

use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class BottomNavItemClicked
{
    use Dispatchable, SerializesModels;

    /**
     * Create a new event instance.
     */
    public function __construct(
        public string $id,
        public ?string $action = null,
        public ?string $url = null,
        public ?string $label = null
    ) {}
}