var allowSmoothMouse = true;
var isMouseDown = false;
var mouseScrollMoving = false;
var nextScrollComingFromMouseWheel = false;
var mousewheelScrollSpeed = 120;
var mouseScrollSmooting = 1.0 / 12.0;
let mouseScrollTarget = (document.scrollingElement || document.documentElement || document.body.parentNode || document.body);
var mouseScrollTopYTarget = mouseScrollTarget.scrollTop;
let container = document.querySelector("#container")
let layers = document.querySelectorAll(".parallax")

window.addEventListener("scroll", onScroll);

function onScroll(e) {
    updateScroll();
}

function updateScroll() {

    for (let index = 0; index < layers.length; index++) {
        const layer = layers[index];

        let width = container.clientWidth
        let top = mouseScrollTarget.scrollTop;
        
        let threshmin = parseFloat(layer.getAttribute("threshmin"))
        let threshmax = parseFloat(layer.getAttribute("threshmax"))
        let range = threshmax - threshmin

        let pastThresh = top - threshmin;

        let progress = Math.min(pastThresh / range)

        $(layer).css("transform", "translate3d(0px, " + top + "px, 0px")

        if (layer.id == "parallax-1") {
            let exStart = threshmin
            let exEnd = threshmax

            let progressPos = easeInOutQuad(Math.min(Math.max(top - exStart, 0) / (exEnd - exStart), 1));
            let progressScale = easeInOutQuad(Math.min(Math.max(top - exStart, 0) / (exEnd - exStart), 1));
            let pos = 300 + (-280 * progressPos)
            let scale = 300 + (-130 * progressScale)
            
            $(layer).css("top", pos)
            $("#logoContainer").css("height", scale)
        } else {
            $(layer).css("transform", "translate3d(0px, " + top / parseFloat(layer.getAttribute("speed")) + "px, 0px")
        }

        let fadeElements = document.querySelectorAll(".fade");

        for (let index = 0; index < fadeElements.length; index++) {
            const element = fadeElements[index];

            let fadeStart = parseFloat(element.getAttribute("fade-start"))
            let fadeEnd = parseFloat(element.getAttribute("fade-end"))
    
            let logoProgress = Math.min((top - fadeEnd) / (fadeStart - fadeEnd))
            $(element).css("opacity", logoProgress)
        }
    }
}

// Event listeners for mouse wheel scroll
if(allowSmoothMouse) {
    window.addEventListener('mousewheel', mousewheelScroll, { passive: false });
    window.addEventListener('DOMMouseScroll', mousewheelScroll, { passive: false });
    window.addEventListener('mousedown', mouseDown);
    window.addEventListener('mouseup', mouseUp);
}

function mouseDown(e) {
    isMouseDown = true;
}

function mouseUp(e) {
    isMouseDown = false;
}

function mousewheelScroll(e) {
    var scrollViewHeight = Math.min(document.documentElement.clientHeight, mouseScrollTarget.clientHeight);
    var delta = -normalizeWheelDelta(e) * mousewheelScrollSpeed;
    var newTarget = mouseScrollTopYTarget + delta;
    newTarget = clamp(newTarget, 0, document.body.clientHeight - scrollViewHeight); // limit scrolling

    e.preventDefault(); // disable default scrolling
    mouseScrollTopYTarget = newTarget;

    // if not animating, start animating
    if (!mouseScrollMoving) {
        mouseScrollMoving = true;
        updateMouseScroll();
    }
}

function updateMouseScroll() {
    if(!mouseScrollMoving) return;

    var delta = (mouseScrollTopYTarget - mouseScrollTarget.scrollTop);

    if(Math.abs(delta) > 0.5) {
        var moveY = (delta * mouseScrollSmooting);
        if(Math.abs(moveY) < 1) {
            moveY = Math.sign(delta);
        }

        nextScrollComingFromMouseWheel = true;
        var newTop = mouseScrollTarget.scrollTop + moveY;
        mouseScrollTarget.scrollTop = newTop;

        updateScroll()

        requestFrame(updateMouseScroll);
    } else {
        if(mouseScrollTopYTarget <= 1) {
            mouseScrollTarget.scrollTop = mouseScrollTopYTarget;
        }
        mouseScrollMoving = false;
    }
}

function normalizeWheelDelta(e){
    if(e.detail){
        if(e.wheelDelta)
            return e.wheelDelta/e.detail/40 * (e.detail>0 ? 1 : -1) // Opera
        else
            return -e.detail/3 // Firefox
    } else {
        return e.wheelDelta/120 // IE,Edge,Safari,Chrome
    }
}

function clamp(val, min, max) {
    return Math.min(Math.max(val, min), max);
}

var requestFrame = (function() { // requestAnimationFrame cross browser
    return (
        window.requestAnimationFrame ||
        window.webkitRequestAnimationFrame ||
        window.mozRequestAnimationFrame ||
        window.oRequestAnimationFrame ||
        window.msRequestAnimationFrame ||
        function(func) {
            window.setTimeout(func, 1000 / 50);
        }
    );
})();

function easeInOutQuad(t) { return t < .5 ? 2 * t * t : -1 + (4 - 2 * t) * t }
function easeInQuad (t) { return t*t }
