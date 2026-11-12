document.addEventListener("DOMContentLoaded", () => {
  const emailInput = document.getElementById("email");
  const codeInput = document.getElementById("recovery-code");
  const passwordInput = document.getElementById("password");
  const confirmInput = document.getElementById("confirm");
  const submitButton = document.getElementById("submit-reset");

  const endpoint = "/api/sandbox.tankio/v1/user/password-recovery/update";

  const showMessage = (message) => {
    window.alert(message);
  };

  submitButton?.addEventListener("click", async () => {
    const email = emailInput?.value?.trim() || "";
    const code = codeInput?.value?.trim() || "";
    const password = passwordInput?.value || "";
    const confirmPassword = confirmInput?.value || "";

    if (!email) {
      showMessage("Email is required.");
      return;
    }

    if (!code) {
      showMessage("Recovery code is required.");
      return;
    }

    if (!password || !confirmPassword) {
      showMessage("Please complete both password fields.");
      return;
    }

    if (password !== confirmPassword) {
      showMessage("Password and confirmation must match.");
      return;
    }

    try {
      const response = await fetch(endpoint, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          email,
          code,
          password,
        }),
      });

      const result = await response.json().catch(() => null);

      if (!response.ok) {
        throw new Error(result?.message || "Unable to submit recovery data.");
      }

      showMessage("Recovery data sent successfully.");
      console.log("Recovery response:", result);
    } catch (error) {
      showMessage(error.message || "Unexpected error.");
    }
  });
});
