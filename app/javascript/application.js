// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import { fas } from "@fortawesome/free-solid-svg-icons";
import { far } from "@fortawesome/free-regular-svg-icons";
import { fab } from "@fortawesome/free-brands-svg-icons";
import { library } from "@fortawesome/fontawesome-svg-core";
import "@fortawesome/fontawesome-free";
library.add(fas, far, fab);

document.addEventListener("DOMContentLoaded", function () {
  const addAlarmButton = document.getElementById("add-alarm-button");
  const removeAlarmButton = document.getElementById("remove-alarm-button");
  const alarmFieldsContainer = document.querySelector(".alarm_fields");

  let alarmIndex = 0;

  addAlarmButton.addEventListener("click", function () {
    alarmIndex++;
    const newAlarmField = document.createElement("div");

    const wakeUpTime = new Date();
    wakeUpTime.setHours(7, 0, 0, 0);
    wakeUpTime.setDate(wakeUpTime.getDate() + alarmIndex + 1);

    const localWakeUpTime = new Date(
      wakeUpTime.getTime() - wakeUpTime.getTimezoneOffset() * 60000
    );

    const wakeUpTimeString = localWakeUpTime.toISOString().slice(0, 16);

    newAlarmField.innerHTML = `
      <div class="mb-4">
        <label class="font-bold">起床時刻</label>
        <input type="datetime-local" name="alarms[${alarmIndex}][wake_up_time]" value="${wakeUpTimeString}" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm">
      </div>

      <div class="mb-4">
        <label class="font-bold">Youtube動画のURL（任意）</label>
        <input type="text" name="alarms[${alarmIndex}][custom_video_url]" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm">
      </div>
    `;
    alarmFieldsContainer.appendChild(newAlarmField);
  });

  removeAlarmButton.addEventListener("click", function () {
    if (alarmIndex > 0) {
      alarmFieldsContainer.lastElementChild.remove();
      alarmIndex--;
    } else {
      alert("削除するフォームがありません。");
    }
  });
});
