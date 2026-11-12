const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

const startBtn = document.getElementById("startBtn");
const resetBtn = document.getElementById("resetBtn");
const statusEl = document.getElementById("status");
const questionEl = document.getElementById("question");
const recognizedTextEl = document.getElementById("recognizedText");
const productValueEl = document.getElementById("productValue");
const amountValueEl = document.getElementById("amountValue");
const confirmValueEl = document.getElementById("confirmValue");

let recognition = null;
let currentStep = "product";
let isFlowActive = false;
let recognitionStarted = false;
let waitingForAnswer = false;
let selectedVoice = null;

const saleData = {
  product: null,
  programmingType: null,
  amount: null,
  amountUnit: null,
  confirm: null,
};

const stepConfig = {
  product: {
    id: "product",
    text: "¿Cuál producto deseas tanquear? Puedes decir corriente, extra o diesel.",
    type: "option",
    validAnswers: ["corriente", "extra", "diesel"],
  },
  programmingType: {
    id: "programmingType",
    text: "¿Qué tipo de programación deseas? Dinero, volumen o full.",
    type: "option",
    validAnswers: ["dinero", "volumen", "full"],
  },
  amountMoney: {
    id: "amountMoney",
    text: "¿Cuál es el valor de dinero?",
    type: "number",
  },
  amountVolume: {
    id: "amountVolume",
    text: "La programación es en galones. ¿Cuál es el valor en galones?",
    type: "number",
  },
  confirm: {
    id: "confirm",
    text: "¿Deseas confirmar la programación? Responde sí o no.",
    type: "option",
    validAnswers: ["si", "sí", "no"],
  },
};

function setStatus(message) {
  statusEl.textContent = message;
}

function normalizeText(text) {
  return text
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[.,;:!?]/g, "")
    .trim();
}

function selectPreferredVoice() {
  const voices = window.speechSynthesis.getVoices();
  if (!voices.length) return null;

  const preferredNames = [
    "Microsoft Helena Online (Natural) - Spanish (Spain)",
    "Microsoft Sabina Online (Natural) - Spanish (Spain)",
    "Google español",
    "Google español de España",
    "Microsoft Helena Desktop - Spanish (Spain)",
    "Microsoft Sabina Desktop - Spanish (Spain)",
  ];

  const normalizedVoices = voices.map((voice) => ({
    voice,
    name: normalizeText(voice.name),
    lang: normalizeText(voice.lang),
  }));

  for (const preferredName of preferredNames) {
    const target = normalizeText(preferredName);
    const match = normalizedVoices.find(({ name }) => name.includes(target));
    if (match) return match.voice;
  }

  const spanishFemaleHint = normalizedVoices.find(({ voice, name, lang }) => {
    return (
      (lang.startsWith("es") || name.includes("spanish")) &&
      (name.includes("female") ||
        name.includes("helena") ||
        name.includes("sabina") ||
        name.includes("maria") ||
        name.includes("carmen") ||
        name.includes("monica") ||
        name.includes("paulina"))
    );
  });

  if (spanishFemaleHint) return spanishFemaleHint.voice;

  const spanishVoice = normalizedVoices.find(({ voice, lang, name }) => {
    return lang.startsWith("es") || name.includes("spanish");
  });

  return spanishVoice ? spanishVoice.voice : voices[0];
}

function refreshVoices() {
  selectedVoice = selectPreferredVoice();
  if (selectedVoice) {
    console.log("Voz seleccionada:", selectedVoice.name, selectedVoice.lang);
  }
}

if ("speechSynthesis" in window) {
  refreshVoices();
  window.speechSynthesis.onvoiceschanged = refreshVoices;
}

function setupRecognition() {
  if (!SpeechRecognition) {
    setStatus("Tu navegador no soporta reconocimiento de voz. Usa Chrome o Edge.");
    startBtn.disabled = true;
    return false;
  }

  if (recognition) {
    return true;
  }

  recognition = new SpeechRecognition();
  recognition.lang = "es-CO";
  recognition.continuous = false;
  recognition.interimResults = false;
  recognition.maxAlternatives = 1;

  recognition.onstart = () => {
    recognitionStarted = true;
    setStatus("Micrófono activo. Responde ahora.");
  };

  recognition.onresult = (event) => {
    const transcript = event.results[0][0].transcript;
    recognizedTextEl.textContent = transcript;
    setStatus("Respuesta recibida. Validando...");
    waitingForAnswer = false;
    handleAnswer(transcript);
  };

  recognition.onerror = (event) => {
    console.error("Speech recognition error:", event.error);
    recognitionStarted = false;
    waitingForAnswer = false;
    setStatus(`Error de micrófono: ${event.error}`);

    if (isFlowActive) {
      speak("No logré escucharte bien. Repetiré la pregunta.", () => {
        askCurrentQuestion();
      });
    }
  };

  recognition.onend = () => {
    recognitionStarted = false;
    console.log("Reconocimiento finalizado");

    if (isFlowActive && waitingForAnswer) {
      setTimeout(() => {
        startListening();
      }, 200);
    }
  };

  return true;
}

function speak(text, onEnd) {
  waitingForAnswer = false;
  window.speechSynthesis.cancel();

  const utterance = new SpeechSynthesisUtterance(text);
  utterance.lang = "es-CO";
  utterance.rate = 0.95;
  utterance.pitch = 1;
  if (selectedVoice) {
    utterance.voice = selectedVoice;
  }

  utterance.onstart = () => {
    setStatus("Reproduciendo pregunta...");
  };

  utterance.onend = () => {
    if (typeof onEnd === "function") {
      onEnd();
    }
  };

  utterance.onerror = (event) => {
    console.error("Speech synthesis error:", event);
    setStatus("Error reproduciendo audio.");
  };

  window.speechSynthesis.speak(utterance);
}

function getCurrentQuestion() {
  if (currentStep === "product") return stepConfig.product;
  if (currentStep === "programmingType") return stepConfig.programmingType;
  if (currentStep === "amountMoney") return stepConfig.amountMoney;
  if (currentStep === "amountVolume") return stepConfig.amountVolume;
  if (currentStep === "confirm") return stepConfig.confirm;
  return null;
}

function askCurrentQuestion() {
  if (!isFlowActive) return;

  const currentQuestion = getCurrentQuestion();
  if (!currentQuestion) return;

  questionEl.textContent = currentQuestion.text;
  recognizedTextEl.textContent = "---";

  speak(currentQuestion.text, () => {
    waitingForAnswer = true;
    startListening();
  });
}

function startListening() {
  if (!recognition || !isFlowActive || recognitionStarted) return;

  try {
    recognition.start();
  } catch (error) {
    console.warn("Recognition already started or unavailable:", error);
  }
}

function parseAmount(text) {
  const onlyDigits = text.replace(/[^0-9]/g, "");

  if (onlyDigits) {
    return Number(onlyDigits);
  }

  const values = {
    "diez mil": 10000,
    "veinte mil": 20000,
    "treinta mil": 30000,
    "cuarenta mil": 40000,
    "cincuenta mil": 50000,
    "sesenta mil": 60000,
    "setenta mil": 70000,
    "ochenta mil": 80000,
    "noventa mil": 90000,
    "cien mil": 100000,
  };

  for (const [label, value] of Object.entries(values)) {
    if (text.includes(label)) {
      return value;
    }
  }

  return null;
}

function parseVolumeAmount(text) {
  const cleaned = normalizeText(text).replace(/\bgalones?\b/g, "").trim();
  const compact = cleaned.replace(/\s+/g, "");

  if (/^\d+(?:[.,]\d+)?$/.test(compact)) {
    const parsed = Number(compact.replace(",", "."));
    return Number.isFinite(parsed) ? parsed : null;
  }

  const wordDigits = {
    cero: "0",
    uno: "1",
    una: "1",
    dos: "2",
    tres: "3",
    cuatro: "4",
    cinco: "5",
    seis: "6",
    siete: "7",
    ocho: "8",
    nueve: "9",
  };

  const assembled = cleaned
    .replace(/\bpunto\b/g, ".")
    .split(/\s+/)
    .filter(Boolean)
    .map((part) => wordDigits[part] ?? part)
    .join("");

  if (!assembled) {
    return null;
  }

  const parsed = Number(assembled.replace(",", "."));
  return Number.isFinite(parsed) ? parsed : null;
}

function setAmountDisplay(value) {
  amountValueEl.textContent = Number(value).toLocaleString("es-CO", {
    maximumFractionDigits: 3,
  });
}

async function sendProgrammingToServer(payload) {
  console.log("Enviando programacion al backend:", payload);
  const baseurl = "https://subdivinely-unreciprocal-hee.ngrok-free.dev";

  const response = await fetch(`${baseurl}/insepet-autoservice/api/v1/web/registrar-programacion`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(payload),
  });

  const data = await response.json();

  if (!response.ok) {
    throw new Error(data.message || "No se pudo registrar la programacion");
  }

  console.log("Respuesta del backend:", data);
  return data;
}
function finishFlow() {
  isFlowActive = false;
  startBtn.disabled = false;

  const amountLabel = saleData.amountUnit === "galones"
    ? `${saleData.amount} galones`
    : saleData.amountUnit === "pesos"
      ? `${saleData.amount} pesos`
      : `${saleData.amount}`;

  const summary = `Programacion finalizada. Producto ${saleData.product}, tipo ${saleData.programmingType}, valor ${amountLabel}, confirmacion ${saleData.confirm}.`;
  setStatus("Flujo finalizado");

  speak(summary, () => {
    console.log("Resumen final:", saleData);

    if (saleData.confirm === "si") {
      sendProgrammingToServer({
        producto: saleData.product,
        tipo_programacion: saleData.programmingType,
        valor: saleData.amount,
        unidad_programacion: saleData.amountUnit,
        confirmacion: saleData.confirm,
      }).catch((error) => {
        console.error("Error registrando programacion:", error);
        setStatus("La programacion se completo, pero no se pudo registrar en el backend.");
      });
    }
  });
}

function goToNextStep(nextStep) {
  currentStep = nextStep;

  if (!currentStep) {
    finishFlow();
    return;
  }

  askCurrentQuestion();
}

function handleAnswer(rawText) {
  const currentQuestion = getCurrentQuestion();
  if (!currentQuestion) return;

  const normalized = normalizeText(rawText);

  if (currentQuestion.type === "option") {
    const validAnswers = currentQuestion.validAnswers.map(normalizeText);
    const matchedAnswer = validAnswers.find((answer) => normalized.includes(answer));

    if (!matchedAnswer) {
      speak("Respuesta no válida. Por favor intenta de nuevo.", () => {
        askCurrentQuestion();
      });
      return;
    }

    if (currentQuestion.id === "product") {
      saleData.product = matchedAnswer;
      productValueEl.textContent = matchedAnswer;
      goToNextStep("programmingType");
      return;
    }

    if (currentQuestion.id === "programmingType") {
      saleData.programmingType = matchedAnswer;

      if (matchedAnswer === "full") {
        saleData.amount = 999999;
        saleData.amountUnit = "full";
        amountValueEl.textContent = "999.999 full";
        goToNextStep("confirm");
        return;
      }

      if (matchedAnswer === "dinero") {
        saleData.amountUnit = "pesos";
        goToNextStep("amountMoney");
        return;
      }

      if (matchedAnswer === "volumen") {
        saleData.amountUnit = "galones";
        goToNextStep("amountVolume");
        return;
      }
    }

    if (currentQuestion.id === "confirm") {
      saleData.confirm = matchedAnswer === "si" ? "si" : "no";
      confirmValueEl.textContent = saleData.confirm;
      goToNextStep(null);
      return;
    }
  }

  if (currentQuestion.type === "number") {
    const amount = currentQuestion.id === "amountVolume"
      ? parseVolumeAmount(normalized)
      : parseAmount(normalized);

    if (!amount || amount <= 0) {
      speak("No logré identificar el valor. Intenta decir un número válido.", () => {
        askCurrentQuestion();
      });
      return;
    }

    saleData.amount = amount;
    if (saleData.amountUnit === "galones") {
      amountValueEl.textContent = `${Number(amount).toLocaleString("es-CO", {
        maximumFractionDigits: 3,
      })} galones`;
    } else {
      setAmountDisplay(amount);
    }
    goToNextStep("confirm");
  }
}

function resetFlow() {
  isFlowActive = false;
  currentStep = "product";
  saleData.product = null;
  saleData.programmingType = null;
  saleData.amount = null;
  saleData.amountUnit = null;
  saleData.confirm = null;
  recognitionStarted = false;
  waitingForAnswer = false;

  window.speechSynthesis.cancel();

  try {
    recognition?.stop();
  } catch (_) {}

  startBtn.disabled = false;
  setStatus("Esperando inicio");
  questionEl.textContent = "---";
  recognizedTextEl.textContent = "---";
  productValueEl.textContent = "---";
  amountValueEl.textContent = "---";
  confirmValueEl.textContent = "---";
}

startBtn.addEventListener("click", async () => {
  if (!setupRecognition()) return;

  isFlowActive = true;
  currentStep = "product";
  startBtn.disabled = true;

  askCurrentQuestion();
});

resetBtn.addEventListener("click", resetFlow);
