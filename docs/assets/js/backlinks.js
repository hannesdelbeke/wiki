

// Function to add classes to backlinks section if it's the last header in the file
function addBacklinkClasses() {
    // Select all h3 elements that start with "backlinks"
    var backlinksHeaders = document.querySelectorAll('h1[id^="backlinks"], h2[id^="backlinks"], h3[id^="backlinks"], h4[id^="backlinks"], h5[id^="backlinks"], h6[id^="backlinks"]');

    // Check if there are any backlinks headers
    if (backlinksHeaders.length > 0) {
        // Select the last backlinks header
        var lastBacklinksHeader = backlinksHeaders[backlinksHeaders.length - 1];

        // Add class "backlink header" to the last backlinks header
        lastBacklinksHeader.classList.add("backlinks", "header");

        // Select the ul element that comes after the last backlinks header
        var ulElement = lastBacklinksHeader.nextElementSibling;

        // Add class "backlink ul" to the ul element
        if (ulElement) {
            ulElement.classList.add("backlinks", "ul");
        }
    }
}

// Call the function to add classes to the backlinks section
addBacklinkClasses();