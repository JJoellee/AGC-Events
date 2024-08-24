document.addEventListener("DOMContentLoaded", function() {
    const params = new URLSearchParams(window.location.search);
    const eventName = params.get('event');

    if (eventName) {
        // Fetch and display event details based on the event name
        // This could include fetching JSON data or just changing content dynamically
        document.querySelector("h1").textContent = `Event Title: ${eventName}`;
        document.querySelector("img.event-main-image").src = `events/${eventName}/main-image.jpg`;
        // You can fetch and display other details similarly
    }
});
