<script>
import MapView from './components/MapView.vue'
import FloatingButtons from './components/FloatingButtons.vue'
import BottomSheet from './components/BottomSheet.vue'

export default {
    name: 'App',
    components: {
        MapView,
        FloatingButtons,
        BottomSheet,
    },
    data() {
        return {
            // Sheet positions (pixels from bottom)
            positions: {
                collapsed: 0,
                middle: 0,
                expanded: 0,
            },

            currentPosition: 'collapsed',
            sheetOffset: 0,

            // Touch/Mouse tracking
            isDragging: false,
            startY: 0,
            startOffset: 0,

            // Window dimensions
            windowHeight: 0,

            // Collapsed height
            collapsedHeight: 120,
        }
    },

    computed: {
        currentPositionName() {
            const names = {
                collapsed: 'Collapsed',
                middle: 'Middle (50%)',
                expanded: 'Expanded',
            }
            return names[this.currentPosition]
        },

        // Floating element moves with sheet until middle position
        floatingElementOffset() {
            if (!this.windowHeight) return 0
            
            const middleOffset = this.positions.middle
            const currentOffset = this.sheetOffset
            const collapsedOffset = this.positions.collapsed
            
            // Calculate how much sheet has moved from collapsed position
            const movement = collapsedOffset - currentOffset
            
            // Buttons should move with sheet from collapsed to middle
            // Distance from collapsed to middle
            const maxMovement = collapsedOffset - middleOffset
            
            // Limit movement to maxMovement
            const actualMovement = Math.min(movement, maxMovement)
            
            return -actualMovement
        }
    },

    mounted() {
        this.calculatePositions()
        window.addEventListener('resize', this.calculatePositions)

        // Set initial position
        this.sheetOffset = this.positions.collapsed

        // Add mouse move and up listeners for desktop
        document.addEventListener('mousemove', this.handleMouseMove)
        document.addEventListener('mouseup', this.handleMouseUp)
    },

    beforeUnmount() {
        window.removeEventListener('resize', this.calculatePositions)
        document.removeEventListener('mousemove', this.handleMouseMove)
        document.removeEventListener('mouseup', this.handleMouseUp)
    },

    methods: {
        calculatePositions() {
            this.windowHeight = window.innerHeight

            // Collapsed: only top part visible (120px from bottom)
            this.positions.collapsed = this.windowHeight - this.collapsedHeight

            // Middle: 50% of screen
            this.positions.middle = this.windowHeight * 0.5

            // Expanded: top of screen (with small margin)
            this.positions.expanded = 60

            // Update current offset if not dragging
            if (!this.isDragging) {
                this.sheetOffset = this.positions[this.currentPosition]
            }
        },

        handleTouchStart(e) {
            this.isDragging = true
            this.startY = e.touches[0].clientY
            this.startOffset = this.sheetOffset
        },

        handleTouchMove(e) {
            if (!this.isDragging) return

            e.preventDefault()
            const currentY = e.touches[0].clientY
            const deltaY = currentY - this.startY

            let newOffset = this.startOffset + deltaY

            // Constrain between expanded and collapsed
            newOffset = Math.max(this.positions.expanded, Math.min(this.positions.collapsed, newOffset))

            this.sheetOffset = newOffset
        },

        handleTouchEnd() {
            if (!this.isDragging) return

            this.isDragging = false
            this.snapToNearestPosition()
        },

        // Mouse events for desktop testing
        handleMouseDown(e) {
            this.isDragging = true
            this.startY = e.clientY
            this.startOffset = this.sheetOffset
            e.preventDefault()
        },

        handleMouseMove(e) {
            if (!this.isDragging) return

            const currentY = e.clientY
            const deltaY = currentY - this.startY

            let newOffset = this.startOffset + deltaY

            // Constrain between expanded and collapsed
            newOffset = Math.max(this.positions.expanded, Math.min(this.positions.collapsed, newOffset))

            this.sheetOffset = newOffset
        },

        handleMouseUp() {
            if (!this.isDragging) return

            this.isDragging = false
            this.snapToNearestPosition()
        },

        snapToNearestPosition() {
            const { expanded, middle, collapsed } = this.positions
            const current = this.sheetOffset

            // Find nearest position
            const distances = {
                expanded: Math.abs(current - expanded),
                middle: Math.abs(current - middle),
                collapsed: Math.abs(current - collapsed)
            }

            const nearest = Object.keys(distances).reduce((a, b) =>
                distances[a] < distances[b] ? a : b
            )

            this.currentPosition = nearest
            this.animateToPosition(this.positions[nearest])
        },

        animateToPosition(targetOffset) {
            const start = this.sheetOffset
            const distance = targetOffset - start
            const duration = 300 // ms
            const startTime = performance.now()

            const animate = (currentTime) => {
                const elapsed = currentTime - startTime
                const progress = Math.min(elapsed / duration, 1)

                // Ease out cubic
                const easeProgress = 1 - Math.pow(1 - progress, 3)

                this.sheetOffset = start + (distance * easeProgress)

                if (progress < 1) {
                    requestAnimationFrame(animate)
                }
            }

            requestAnimationFrame(animate)
        }
    }
}
</script>

<template>
    <div class="app">
        <!-- Map Background -->
        <MapView />

        <!-- Floating Buttons -->
        <FloatingButtons :offset="floatingElementOffset" />

        <!-- Bottom Sheet -->
        <BottomSheet
            :offset="sheetOffset"
            :position-name="currentPositionName"
            @touchstart="handleTouchStart"
            @touchmove="handleTouchMove"
            @touchend="handleTouchEnd"
            @mousedown="handleMouseDown"
        />
    </div>
</template>

<style scoped>
.app {
    width: 100%;
    height: 100vh;
    position: relative;
    overflow: hidden;
    background: #f0f0f0;
}
</style>
