<script>
export default {
    name: 'MapView',
}
</script>

<template>
    <div class="map-container">
        <div class="map-placeholder">
            <div class="map-text">iOS Maps</div>
        </div>
    </div>
</template>

<style scoped>
.map-container {
    width: 100%;
    height: 100%;
    position: absolute;
    top: 0;
    left: 0;
}

.map-placeholder {
    width: 100%;
    height: 100%;
    background: linear-gradient(135deg, #7FB069 0%, #B8D4BE 30%, #9DC3E6 60%, #5B9BD5 100%);
    display: flex;
    align-items: center;
    justify-content: center;
}

.map-text {
    color: white;
    font-size: 24px;
    font-weight: 600;
    opacity: 0.5;
}
</style>
