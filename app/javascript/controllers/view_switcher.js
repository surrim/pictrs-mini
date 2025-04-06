import "js-cookie";

function initViewMode() {
  const viewMode = document.querySelector("#view-mode");
  if (viewMode) {
    viewMode.value = Cookies.get("view");
    viewMode.onchange = function(event) {
      Cookies.set("view", event.target.value);
      window.location.reload();
    };
  }
}

document.addEventListener("DOMContentLoaded", initViewMode);
document.addEventListener("turbo:load", initViewMode);
