function a(t){t.addEventListener("click",e=>{e.preventDefault(),e.target.classList.toggle("-active")})}document.querySelectorAll(".annotation-trigger").forEach(a);function n(t){const e=document.querySelector(t.dataset.target);t.addEventListener("click",o=>{e.classList.toggle("expand")})}document.querySelectorAll("[data-behavior~=toggle-hidden]").forEach(n);
//# sourceMappingURL=application.2826b514.js.map