<script>
export default {
    name: 'BottomSheet',
    props: {
        offset: {
            type: Number,
            required: true,
        },
        positionName: {
            type: String,
            required: true,
        }
    },
    emits: ['touchstart', 'touchmove', 'touchend', 'mousedown'],
}
</script>

<template>
    <div
        class="bottom-sheet"
        :style="{ transform: `translateY(${offset}px)` }"
        @touchstart="$emit('touchstart', $event)"
        @touchmove="$emit('touchmove', $event)"
        @touchend="$emit('touchend', $event)"
        @mousedown="$emit('mousedown', $event)"
    >
        <!-- Handle -->
        <div class="sheet-handle">
            <div class="handle-bar"></div>
        </div>

        <!-- Content -->
        <div class="sheet-content">
            <h2>Bottom Sheet</h2>
            <p>Drag up or down</p>
            <div class="position-info">
                <div class="position-label">Current position:</div>
                <div class="position-value">{{ positionName }}</div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.bottom-sheet {
    position: fixed;
    left: 0;
    top: 0;
    width: 100%;
    height: 100vh;
    background: white;
    border-radius: 16px 16px 0 0;
    box-shadow: 0 -2px 20px rgba(0, 0, 0, 0.15);
    z-index: 1000;
    will-change: transform;
    touch-action: none;
}

.sheet-handle {
    width: 100%;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: grab;
    padding: 12px 0;
}

.sheet-handle:active {
    cursor: grabbing;
}

.handle-bar {
    width: 36px;
    height: 5px;
    background: #C7C7CC;
    border-radius: 3px;
}

.sheet-content {
    padding: 20px 24px;
    overflow-y: auto;
    height: calc(100vh - 40px);
}

.sheet-content h2 {
    font-size: 28px;
    font-weight: 700;
    margin-bottom: 8px;
    color: #000;
}

.sheet-content p {
    font-size: 16px;
    color: #666;
    margin-bottom: 24px;
}

.position-info {
    padding: 16px;
    background: #F2F2F7;
    border-radius: 12px;
    text-align: center;
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.position-label {
    font-size: 13px;
    color: #8E8E93;
}

.position-value {
    font-size: 15px;
    color: #007AFF;
    font-weight: 600;
}
</style>
