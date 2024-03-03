// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import { fas } from "@fortawesome/free-solid-svg-icons";
import { far } from "@fortawesome/free-regular-svg-icons";
import { fab } from "@fortawesome/free-brands-svg-icons";
import { library } from "@fortawesome/fontawesome-svg-core";
import "@fortawesome/fontawesome-free";
library.add(fas, far, fab);

document.addEventListener("DOMContentLoaded", () => {
  const addAlarmButton = document.getElementById("add-alarm-button");
  const alarmsFields = document.getElementById("alarms-fields");
  const alarmTemplate = document.getElementById("alarm-template").innerHTML;

  addAlarmButton.addEventListener("click", () => {
    const newIndex = alarmsFields.children.length;
    const newAlarmFields = createAlarmFields(newIndex, alarmTemplate);
    alarmsFields.insertAdjacentHTML("beforeend", newAlarmFields);
  });

  function createAlarmFields(index, template) {
    const daysToAdd = index + 1;
    const wakeUpTime = new Date();
    wakeUpTime.setDate(wakeUpTime.getDate() + daysToAdd);
    wakeUpTime.setHours(0, 7, 0, 0);

    const localWakeUpTime = new Date(
      wakeUpTime.getTime() - wakeUpTime.getTimezoneOffset() * 60000
    );

    const wakeUpTimeString = localWakeUpTime.toISOString().slice(0, 16);

    return template
      .replace(/TEMPLATE_INDEX/g, index)
      .replace(/wakeupTimeValue/g, wakeUpTimeString);
  }
});
