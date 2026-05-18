<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
  <title>💥 EXPLODE FOR BRAINROTS | SSDomainHub</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      min-height: 100vh;
      background: linear-gradient(145deg, #0a0a1a 0%, #0c1125 100%);
      font-family: 'Poppins', 'Segoe UI', system-ui, 'Inter', sans-serif;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      overflow-x: hidden;
    }

    /* Background gambar game Roblox (high quality) */
    body::before {
      content: "";
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-image: url('https://wallpapercave.com/wp/wp7876907.jpg');
      background-size: cover;
      background-position: center 30%;
      background-repeat: no-repeat;
      filter: brightness(0.35) blur(2.5px);
      z-index: -2;
    }

    body::after {
      content: "";
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: radial-gradient(circle at 20% 30%, rgba(0,0,0,0.4) 0%, rgba(0,0,0,0.8) 100%);
      z-index: -1;
    }

    .watermark {
      position: fixed;
      bottom: 16px;
      right: 20px;
      font-size: 0.8rem;
      font-weight: 500;
      color: rgba(255,240,200,0.7);
      background: rgba(0,0,0,0.5);
      backdrop-filter: blur(6px);
      padding: 6px 16px;
      border-radius: 60px;
      font-family: monospace;
      z-index: 99;
      pointer-events: none;
      border: 1px solid rgba(255,215,0,0.4);
      letter-spacing: 0.5px;
    }

    .container {
      max-width: 850px;
      width: 92%;
      margin: 2rem auto;
      padding: 2rem 1.8rem;
      background: rgba(12, 20, 32, 0.7);
      backdrop-filter: blur(14px);
      border-radius: 56px;
      border: 1px solid rgba(255, 200, 70, 0.6);
      box-shadow: 0 30px 45px rgba(0,0,0,0.5), 0 0 0 1px rgba(255,200,0,0.2) inset;
      text-align: center;
      transition: all 0.3s;
    }

    h1 {
      font-size: 2.4rem;
      font-weight: 800;
      background: linear-gradient(135deg, #FFDD77, #FFAA33, #FF7700);
      -webkit-background-clip: text;
      background-clip: text;
      color: transparent;
      text-shadow: 0 2px 5px rgba(0,0,0,0.4);
      letter-spacing: -0.5px;
      margin-bottom: 0.5rem;
    }

    .sub {
      color: #ddd9ce;
      font-weight: 500;
      margin-bottom: 1.8rem;
      border-bottom: 1px dashed rgba(255,200,100,0.6);
      display: inline-block;
      padding-bottom: 6px;
      font-size: 1rem;
    }

    /* progress steps */
    .steps-progress {
      background: #07111ed4;
      border-radius: 60px;
      padding: 12px 20px;
      margin-bottom: 30px;
      display: flex;
      justify-content: center;
      gap: 35px;
      flex-wrap: wrap;
      border: 1px solid #ffb34766;
    }

    .step-item {
      display: flex;
      align-items: center;
      gap: 10px;
      background: #0a121fd9;
      padding: 6px 18px;
      border-radius: 40px;
      font-weight: 600;
      font-size: 1rem;
    }

    .step-check {
      width: 28px;
      height: 28px;
      border-radius: 50%;
      background: #2c3e33;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-weight: bold;
      transition: 0.2s;
    }

    .step-check.done {
      background: #28a745;
      box-shadow: 0 0 8px #00ff88;
    }

    .step-label {
      color: #eee;
    }

    .cards-wrapper {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 30px;
      margin: 20px 0 25px;
    }

    .follow-card {
      background: rgba(20, 28, 45, 0.85);
      backdrop-filter: blur(8px);
      border-radius: 48px;
      padding: 1.4rem 1.8rem;
      width: 260px;
      cursor: pointer;
      transition: transform 0.2s ease, box-shadow 0.2s;
      border: 1px solid rgba(255, 180, 70, 0.8);
      box-shadow: 0 12px 25px rgba(0,0,0,0.4);
      text-align: center;
    }

    .follow-card:hover {
      transform: translateY(-7px);
      border-color: #ffc107;
      box-shadow: 0 20px 30px rgba(0,0,0,0.6);
      background: rgba(35, 45, 65, 0.95);
    }

    .follow-card.completed {
      border-color: #2ecc71;
      background: rgba(46, 204, 113, 0.2);
      cursor: default;
      opacity: 0.8;
      transform: none;
      filter: drop-shadow(0 0 5px #2ecc71);
    }

    .icon {
      font-size: 3.5rem;
      margin-bottom: 12px;
    }

    .platform-name {
      font-size: 1.6rem;
      font-weight: 700;
      color: #FFE5B4;
    }

    .action-status {
      font-size: 0.75rem;
      margin-top: 8px;
      background: #00000066;
      display: inline-block;
      padding: 4px 12px;
      border-radius: 40px;
      color: #ccc;
    }

    .timer-panel {
      background: #07111ed9;
      margin: 20px auto 15px;
      padding: 20px 15px;
      border-radius: 60px;
      width: 95%;
      backdrop-filter: blur(8px);
      border: 1px solid #ffb347aa;
    }

    .cooldown-text {
      font-size: 1.3rem;
      font-weight: 600;
      color: #FFD966;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 15px;
      flex-wrap: wrap;
    }

    .timer-number {
      background: #000000bb;
      padding: 8px 22px;
      border-radius: 80px;
      font-family: monospace;
      font-size: 2.3rem;
      font-weight: 800;
      letter-spacing: 4px;
      color: #ffaa44;
    }

    .key-section {
      background: linear-gradient(145deg, #0e1a27, #03070e);
      border-radius: 48px;
      padding: 20px 15px;
      margin: 20px 0;
      border: 2px solid gold;
      box-shadow: 0 0 24px rgba(255,215,0,0.4);
    }

    .key-title {
      font-size: 1.9rem;
      font-weight: 800;
      background: linear-gradient(120deg, #FFE08C, #FFAA44);
      -webkit-background-clip: text;
      background-clip: text;
      color: transparent;
    }

    .perm-text {
      color: #bbaa77;
      font-size: 0.9rem;
      margin-top: 5px;
      font-style: italic;
    }

    .key-box {
      background: #000000bb;
      font-family: 'Courier New', monospace;
      font-size: 1.9rem;
      font-weight: bold;
      letter-spacing: 3px;
      padding: 15px 10px;
      margin: 15px auto;
      border-radius: 50px;
      width: fit-content;
      min-width: 280px;
      border: 1px solid #ffcc44;
      color: #FFE484;
      text-shadow: 0 0 5px #ff9900;
      word-break: break-all;
    }

    .copy-btn {
      background: #ffaa33dd;
      border: none;
      font-size: 1.2rem;
      font-weight: bold;
      padding: 12px 32px;
      border-radius: 50px;
      cursor: pointer;
      transition: 0.2s;
      color: #1e2a2f;
      box-shadow: 0 5px 0 #7a3b00;
      margin-top: 10px;
    }

    .copy-btn:active {
      transform: translateY(2px);
      box-shadow: 0 2px 0 #7a3b00;
    }

    .redirect-note {
      font-size: 1.1rem;
      margin-top: 18px;
      color: #FFD966;
      font-weight: bold;
      background: #00000088;
      display: inline-block;
      padding: 8px 24px;
      border-radius: 60px;
    }

    .hidden {
      display: none;
    }

    .info-badge {
      background: #00000077;
      padding: 8px 12px;
      border-radius: 50px;
      font-size: 0.8rem;
      margin-top: 25px;
      color: #ddddcc;
    }

    button:disabled {
      opacity: 0.6;
    }

    @keyframes pulse {
      0% { transform: scale(1); opacity: 0.8; }
      100% { transform: scale(1.02); opacity: 1; }
    }

    .glow-pulse {
      animation: pulse 0.8s infinite alternate;
    }

    footer {
      font-size: 0.7rem;
      margin-top: 18px;
      color: #aaa;
    }
  </style>
</head>
<body>

<div class="watermark">⚡ by: ssdomainhub</div>

<div class="container">
  <h1>💥 EXPLODE FOR BRAINROTS 💥</h1>
  <div class="sub">🔓 COMPLETE BOTH STEPS TO UNLOCK THE KEY</div>

  <!-- Progress indicator for 2 steps -->
  <div class="steps-progress">
    <div class="step-item" id="stepTikTokStatus">
      <span class="step-check" id="tickTikTok">○</span>
      <span class="step-label">TikTok @ssdomain</span>
    </div>
    <div class="step-item" id="stepWAStatus">
      <span class="step-check" id="tickWA">○</span>
      <span class="step-label">WhatsApp Channel</span>
    </div>
  </div>

  <!-- Two cards -->
  <div class="cards-wrapper">
    <div class="follow-card" data-url="https://www.tiktok.com/@ssdomain?_r=1&_t=ZS-96SVbZxkDDQ" data-type="tiktok" id="cardTiktok">
      <div class="icon">🎵</div>
      <div class="platform-name">TikTok</div>
      <div class="action-status" id="tiktokStatusText">⚠️ Not opened yet</div>
    </div>
    <div class="follow-card" data-url="https://whatsapp.com/channel/0029VbCOhBnJkK73p2VAGl3R" data-type="wa" id="cardWa">
      <div class="icon">💬</div>
      <div class="platform-name">WhatsApp Channel</div>
      <div class="action-status" id="waStatusText">⚠️ Not opened yet</div>
    </div>
  </div>

  <!-- Dynamic zones -->
  <div id="dynamicZone">
    <div id="timerArea" class="timer-panel hidden">
      <div class="cooldown-text">
        ⏳ COOLDOWN ACTIVE • WAIT 60 SECONDS ⏳
        <span id="countdownDisplay" class="timer-number">60</span>
        <span>sec</span>
      </div>
      <div style="font-size: 0.8rem; margin-top: 10px;">✅ Both links opened! Cooldown started...<br>Don't close this page.</div>
    </div>

    <div id="keyArea" class="hidden key-section">
      <div class="key-title">💀 KEY EXPLODE FOR BRAINROTS! 💀</div>
      <div class="perm-text">🔐 THIS KEY IS PERMANENT 🔐</div>
      <div class="key-box" id="secretKey">V9#qL2@xP7!m</div>
      <button id="copyKeyBtn" class="copy-btn">📋 COPY TEXT TO CLIPBOARD 📋</button>
      <div id="redirectMessage" class="redirect-note hidden">🚪 MASUK 🚪 → Redirecting to Roblox...</div>
    </div>
  </div>

  <div class="info-badge">
    ⚡ STEP 1: Click on BOTH cards above (open TikTok & WhatsApp Channel in new tabs)<br>
    ⚡ STEP 2: After completing both, 60s cooldown starts → Get secret key → Copy → Auto-redirect to Roblox!
  </div>
  <footer>© BRAINROTS HUB • follow & join required before key unlock</footer>
</div>

<script>
  (function() {
    // Track which links have been opened
    let tiktokOpened = false;
    let waOpened = false;
    let bothCompleted = false;      // both links opened
    let cooldownActive = false;
    let timerInterval = null;
    let remainingSeconds = 60;
    let keyRevealed = false;
    let redirectTriggered = false;

    // DOM elements
    const tiktokCard = document.getElementById('cardTiktok');
    const waCard = document.getElementById('cardWa');
    const tiktokStatusSpan = document.getElementById('tiktokStatusText');
    const waStatusSpan = document.getElementById('waStatusText');
    const tickTikTok = document.getElementById('tickTikTok');
    const tickWA = document.getElementById('tickWA');
    const timerArea = document.getElementById('timerArea');
    const keyArea = document.getElementById('keyArea');
    const countdownSpan = document.getElementById('countdownDisplay');
    const copyBtn = document.getElementById('copyKeyBtn');
    const redirectMsgDiv = document.getElementById('redirectMessage');
    const keyValue = "V9#qL2@xP7!m";

    // Helper: update UI for step completion
    function updateStepsUI() {
      if (tiktokOpened) {
        tickTikTok.innerHTML = "✓";
        tickTikTok.classList.add('done');
        tiktokStatusSpan.innerText = "✅ Opened";
        tiktokCard.classList.add('completed');
      } else {
        tickTikTok.innerHTML = "○";
        tickTikTok.classList.remove('done');
        tiktokStatusSpan.innerText = "⚠️ Not opened yet";
        tiktokCard.classList.remove('completed');
      }
      if (waOpened) {
        tickWA.innerHTML = "✓";
        tickWA.classList.add('done');
        waStatusSpan.innerText = "✅ Opened";
        waCard.classList.add('completed');
      } else {
        tickWA.innerHTML = "○";
        tickWA.classList.remove('done');
        waStatusSpan.innerText = "⚠️ Not opened yet";
        waCard.classList.remove('completed');
      }
    }

    // Stop timer if running
    function stopTimer() {
      if (timerInterval) {
        clearInterval(timerInterval);
        timerInterval = null;
      }
    }

    // Start cooldown after both links are opened
    function startCooldown() {
      if (cooldownActive) return;
      if (!bothCompleted) return;
      if (keyRevealed) return;

      stopTimer();
      remainingSeconds = 60;
      countdownSpan.innerText = remainingSeconds;
      cooldownActive = true;
      timerArea.classList.remove('hidden');
      keyArea.classList.add('hidden');
      redirectMsgDiv.classList.add('hidden');

      timerInterval = setInterval(() => {
        if (remainingSeconds <= 1) {
          // Cooldown finished
          clearInterval(timerInterval);
          timerInterval = null;
          cooldownActive = false;
          timerArea.classList.add('hidden');
          // Reveal key section
          keyArea.classList.remove('hidden');
          keyRevealed = true;
          const keyBoxElem = document.getElementById('secretKey');
          if (keyBoxElem) keyBoxElem.style.animation = 'pulse 0.6s 2';
        } else {
          remainingSeconds--;
          countdownSpan.innerText = remainingSeconds;
        }
      }, 1000);
    }

    // Function to handle opening a link (opens in new tab)
    function openLinkAndMark(url, type) {
      try {
        const win = window.open(url, '_blank');
        if (!win || win.closed || typeof win.closed == 'undefined') {
          // Popup blocked
          const userConfirm = confirm(`⚠️ Pop-up blocked! Please manually open this link:\n${url}\n\nAfter you open it, click OK to confirm.`);
          if (!userConfirm) return false;
        }
      } catch(e) {
        const manualConfirm = confirm(`❌ Cannot open automatically. Please open manually:\n${url}\n\nClick OK after you have opened it.`);
        if (!manualConfirm) return false;
      }
      
      // Mark as opened based on type
      if (type === 'tiktok' && !tiktokOpened) {
        tiktokOpened = true;
      } else if (type === 'wa' && !waOpened) {
        waOpened = true;
      } else {
        // Already opened before, but still we refresh UI
      }
      updateStepsUI();
      
      // Check if both are now completed
      const newBothStatus = tiktokOpened && waOpened;
      if (newBothStatus && !bothCompleted) {
        bothCompleted = true;
        // Both steps done! Now start cooldown automatically.
        startCooldown();
      } else if (!newBothStatus) {
        bothCompleted = false;
      }
      return true;
    }

    // Card click handlers
    function handleCardClick(event, url, type) {
      if (cooldownActive) {
        alert("⏳ Cooldown is already running! Please wait 60 seconds to get your key.");
        return;
      }
      if (keyRevealed) {
        alert("✅ Key already unlocked! Please copy the key and you will be redirected.");
        return;
      }
      if ((type === 'tiktok' && tiktokOpened) || (type === 'wa' && waOpened)) {
        alert(`🔁 You've already opened the ${type === 'tiktok' ? 'TikTok' : 'WhatsApp Channel'} link. Complete the other step to continue.`);
        return;
      }
      
      // Open link and mark step as completed
      openLinkAndMark(url, type);
    }

    // Copy key + redirect to Roblox
    async function copyKeyAndRedirect() {
      if (redirectTriggered) return;
      if (!keyRevealed) {
        alert("🔐 Key is not available yet! Please complete both steps and wait 60 seconds cooldown.");
        return;
      }
      
      // Copy to clipboard
      try {
        await navigator.clipboard.writeText(keyValue);
        const originalText = copyBtn.innerText;
        copyBtn.innerText = "✅ COPIED! ✅";
        setTimeout(() => { if (copyBtn) copyBtn.innerText = originalText; }, 1500);
      } catch (err) {
        alert("⚠️ Could not copy automatically. Please copy manually: " + keyValue);
      }
      
      // Show "Masuk" message and redirect to Roblox game
      redirectMsgDiv.classList.remove('hidden');
      redirectMsgDiv.innerHTML = "🚪 MASUK 🚪 → Entering the portal...";
      redirectTriggered = true;
      
      const robloxUrl = "https://www.roblox.com/id/games/134900709608900/Explode-for-Brainrots";
      setTimeout(() => {
        window.location.href = robloxUrl;
      }, 900);
    }

    // Attach events
    tiktokCard.addEventListener('click', (e) => {
      e.preventDefault();
      const url = tiktokCard.getAttribute('data-url');
      if (url) handleCardClick(e, url, 'tiktok');
    });
    
    waCard.addEventListener('click', (e) => {
      e.preventDefault();
      const url = waCard.getAttribute('data-url');
      if (url) handleCardClick(e, url, 'wa');
    });
    
    if (copyBtn) {
      copyBtn.addEventListener('click', copyKeyAndRedirect);
    }
    
    // Reset all states on page load (fresh start)
    function fullReset() {
      stopTimer();
      tiktokOpened = false;
      waOpened = false;
      bothCompleted = false;
      cooldownActive = false;
      keyRevealed = false;
      redirectTriggered = false;
      timerArea.classList.add('hidden');
      keyArea.classList.add('hidden');
      redirectMsgDiv.classList.add('hidden');
      remainingSeconds = 60;
      if (countdownSpan) countdownSpan.innerText = "60";
      updateStepsUI();
      // re-enable card pointer-events (already enabled)
      tiktokCard.style.pointerEvents = "auto";
      waCard.style.pointerEvents = "auto";
    }
    
    fullReset();
    
    // Extra safety: if user somehow clicks copy before key revealed, alert handled inside copy function
    console.log("🔥 SSDomainHub | Two-step verification active | Both TikTok & WA required before cooldown");
  })();
</script>
</body>
</html>
