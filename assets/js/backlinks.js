// Function to add classes to backlinks section if it's the last header in the file
function addBacklinkClasses() {
    // Select all header elements
    var headerElements = document.querySelectorAll('h1[id^="backlinks"], h2[id^="backlinks"], h3[id^="backlinks"], h4[id^="backlinks"], h5[id^="backlinks"], h6[id^="backlinks"]');

    // Check if there are any header elements
    if (headerElements.length > 0) {
        // Select the last header element
        var lastHeader = headerElements[headerElements.length - 1];

        // Add class "backlink header" to the last header
        lastHeader.classList.add("backlink", "header");

        // Select the ul element that comes after the last header
        var ulElement = lastHeader.nextElementSibling;

        // Add class "backlink ul" to the ul element
        if (ulElement) {
            ulElement.classList.add("backlink", "ul");

            // Get all child nodes of the ulElement
            var childNodes = ulElement.childNodes;

            // Filter only the li elements
            var backlinkListItems = Array.from(childNodes).filter(function(node) {
                return node.nodeName === 'LI';
            });

            // Loop through each <li> element
            backlinkListItems.forEach(function(li) {
                // Add class "backlinks title" to each <li> element
                li.classList.add("backlinks", "title");

                // Select the nested ul element inside each li
                var nestedUlElement = li.querySelector('ul');

                // Add class "backlinks preview" to the nested ul element
                if (nestedUlElement) {
                    nestedUlElement.classList.add("backlinks", "preview");
                }                
            });
        }
    }
}

// Call the function to add classes to the backlinks section
addBacklinkClasses();
