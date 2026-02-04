<?php

namespace Native\Mobile\Edge\Components\Navigation;

use Native\Mobile\Edge\Components\EdgeComponent;

class SideNav extends EdgeComponent
{
    protected string $type = 'side_nav';

    protected bool $hasChildren = true;

    public function __construct(
        public ?bool $dark = null,
        public string $labelVisibility = 'labeled',
        public bool $gesturesEnabled = false
    ) {}

    protected function toNativeProps(): array
    {
        return [
            'dark' => $this->dark,
            'label_visibility' => $this->labelVisibility,
            'gestures_enabled' => $this->gesturesEnabled,
        ];
    }

    /**
     * Programmatically open the side navigation drawer.
     */
    public static function open(): void
    {
        ray('33: SideNav.php');
        if (function_exists('nativephp_call')) {
            ray('35: SideNav.php');
            nativephp_call('Navigation.OpenSidebar', '{}');
        }
    }

    /**
     * Programmatically close the side navigation drawer.
     */
    public static function close(): void
    {
        if (function_exists('nativephp_call')) {
            nativephp_call('Navigation.CloseSidebar', '{}');
        }
    }

    /**
     * Toggle the side navigation drawer open/closed state.
     */
    public static function toggle(): void
    {
        if (function_exists('nativephp_call')) {
            nativephp_call('Navigation.ToggleSidebar', '{}');
        }
    }
}
