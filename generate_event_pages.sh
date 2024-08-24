#!/bin/bash

REPOSITORY=$1

# Generate index.html
template=$(cat template.html)
events_html=""
for d in events/*/ ; do
    event_id=$(basename $d)
    event_title=$(cat "$d/title.txt")
    event_description=$(cat "$d/description.txt")
    event_html="
        <div class='event-item'>
            <a class='event-link' href='events/${event_id}/event.html'>
                <h3>${event_title}</h3>
                <p>${event_description}</p>
            </a>
        </div>"
    events_html="${events_html}${event_html}"
done
index_html="${template//\{\{EVENTS\}\}/${events_html}}"
echo "$index_html" > index.html

# Generate event.html for each event
event_template=$(cat event_template.html)
for d in events/*/ ; do
    event_id=$(basename $d)
    event_title=$(cat "$d/title.txt")
    event_description=$(cat "$d/description.txt")
    main_image="${d}main-image.jpg"
    
    materials_html=""
    
    for material in ${d}materials/* ; do
        material_name=$(basename $material)
        extension="${material##*.}"
        view_html=""
        
        if [ "$extension" = "pdf" ]; then
            view_html="<iframe src='../../${material}' width='100%' height='600px'></iframe>"
        elif [ "$extension" = "ppt" ] || [ "$extension" = "pptx" ]; then
            view_html="<iframe src='https://view.officeapps.live.com/op/embed.aspx?src=https://raw.githubusercontent.com/${REPOSITORY}/main/${material}' width='100%' height='600px'></iframe>"
        elif [ "$extension" = "doc" ] || [ "$extension" = "docx" ]; then
            view_html="<iframe src='https://view.officeapps.live.com/op/embed.aspx?src=https://raw.githubusercontent.com/${REPOSITORY}/main/${material}' width='100%' height='600px'></iframe>"
        fi
        
        materials_html="${materials_html}<div class='material-item'>${view_html}<a href='../../${material}' download class='download-button'>Download ${material_name}</a></div>"
    done

    event_html="${event_template//\{\{EVENT_TITLE\}\}/${event_title}}"
    event_html="${event_html//\{\{MAIN_IMAGE\}\}/${main_image}}"
    event_html="${event_html//\{\{EVENT_DESCRIPTION\}\}/${event_description}}"
    event_html="${event_html//\{\{EVENT_MATERIALS\}\}/${materials_html}}"

    echo "$event_html" > "${d}event.html"
done
