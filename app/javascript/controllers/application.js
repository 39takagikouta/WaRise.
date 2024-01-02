import { Application } from "@hotwired/stimulus";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };

application.debug = true;

document.addEventListener("DOMContentLoaded", () => {
  const addAlarmButton = document.getElementById("add-alarm-button");
  const alarmsFields = document.getElementById("alarms-fields");

  addAlarmButton.addEventListener("click", () => {
    const newIndex = alarmsFields.children.length;
    const newAlarmFields = createAlarmFields(newIndex);
    alarmsFields.appendChild(newAlarmFields);
  });

  function createAlarmFields(index) {
    const fieldset = document.createElement("fieldset");
    fieldset.innerHTML = `
      <legend>Alarm ${index + 1}</legend>
      <div>
        <label for="alarm_wake_up_time_${index}">Wake up time</label>
        <input type="datetime-local" name="alarms[${index}][wake_up_time]" id="alarm_wake_up_time_${index}">
      </div>
      <div>
        <label for="alarm_custom_video_url_${index}">Custom Video URL</label>
        <input type="text" name="alarms[${index}][custom_video_url]" id="alarm_custom_video_url_${index}">
      </div>
    `;
    return fieldset;
  }
});
