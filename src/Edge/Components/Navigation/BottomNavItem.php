<?php

namespace Native\Mobile\Edge\Components\Navigation;

use Native\Mobile\Edge\Components\EdgeComponent;

class BottomNavItem extends EdgeComponent
{
    protected string $type = 'bottom_nav_item';

    public function __construct(
        public ?string $id = null,
        public ?string $icon = null,
        public ?string $url = null,
        public ?string $action = null,
        public ?string $label = null,
        public bool $active = false,
        public ?string $badge = null,
        public ?string $badgeColor = null,
        public bool $news = false,
    ) {}

    protected function requiredProps(): array
    {
        return ['id', 'icon', 'label'];
    }

    protected function validateProps(): void
    {
        parent::validateProps();

        // Ensure either url or action is set, but not both
        if (empty($this->url) && empty($this->action)) {
            throw new \Native\Mobile\Edge\Exceptions\MissingRequiredPropsException(
                static::class,
                $this->type,
                ['url or action']
            );
        }

        if (!empty($this->url) && !empty($this->action)) {
            throw new \InvalidArgumentException(
                "BottomNavItem cannot have both 'url' and 'action' attributes set. Use either 'url' for navigation or 'action' for custom actions."
            );
        }
    }

    protected function toNativeProps(): array
    {
        return [
            'id' => $this->id,
            'icon' => $this->icon,
            'url' => $this->url,
            'action' => $this->action,
            'label' => $this->label,
            'active' => $this->active,
            'badge' => $this->badge,
            'badge_color' => $this->badgeColor,
            'news' => $this->news,
        ];
    }
}
