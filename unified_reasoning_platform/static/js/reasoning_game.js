let secretWord = '';
let wordLen = 5;
let score = 100;
let attempts = 0;
let timer = 15;
let timerInterval = null;
let gameActive = false;

const wordLists = {
    3: ['CAT', 'DOG', 'MAP', 'SUN', 'BED', 'BOX'],
    4: ['FIRE', 'GOLD', 'HEAT', 'IRON', 'LAMP'],
    5: ['CRANE', 'FLINT', 'BRAVE', 'HEART', 'LEMON', 'MUSIC'],
    6: ['ANIMAL', 'BRIDGE', 'CASTLE', 'EMPIRE', 'GARDEN'],
    7: ['BLANKET', 'CAPTAIN', 'DOLPHIN', 'FACTORY', 'HOLIDAY']
};

function setLen(n, el) {
    wordLen = n;

    document.querySelectorAll('.word-len-btns button').forEach(btn => {
        btn.classList.remove('active');
    });

    el.classList.add('active');
}

function startGame() {
    const list = wordLists[wordLen];
    secretWord = list[Math.floor(Math.random() * list.length)];

    score = 100;
    attempts = 0;
    gameActive = true;

    document.getElementById('setupCard').classList.add('hidden');
    document.getElementById('scoreBar').classList.remove('hidden');
    document.getElementById('guessRow').classList.remove('hidden');
    document.getElementById('guessError').classList.remove('hidden');
    document.getElementById('historySection').classList.remove('hidden');
    document.getElementById('historyList').innerHTML = '';
    document.getElementById('resultCard').classList.add('hidden');

    updateScore();
    startTimer();

    document.getElementById('guessInput').focus();
}

function updateScore() {
    document.getElementById('scoreVal').textContent = score;
    document.getElementById('attemptsVal').textContent =
        attempts + ' attempt' + (attempts !== 1 ? 's' : '');
}

function startTimer() {
    clearInterval(timerInterval);

    timer = 15;
    updateTimer();

    timerInterval = setInterval(() => {
        timer--;
        updateTimer();

        if (timer <= 0) {
            score = Math.max(0, score - 5);
            updateScore();

            if (score === 0) {
                endGame(false);
            } else {
                timer = 15;
            }
        }
    }, 1000);
}

function updateTimer() {
    const mins = Math.floor(timer / 60);
    const secs = timer % 60;

    document.getElementById('timerVal').textContent =
        `${String(mins).padStart(2,'0')}:${String(secs).padStart(2,'0')}`;
}

function evaluateGuess(guess, secret) {
    let matches = 0;
    let misplaced = 0;

    const secretArr = secret.split('');
    const guessArr = guess.split('');

    const usedSecret = Array(secret.length).fill(false);
    const usedGuess = Array(guess.length).fill(false);

    for (let i = 0; i < guess.length; i++) {
        if (guessArr[i] === secretArr[i]) {
            matches++;
            usedSecret[i] = true;
            usedGuess[i] = true;
        }
    }

    for (let i = 0; i < guess.length; i++) {
        if (usedGuess[i]) continue;

        for (let j = 0; j < secret.length; j++) {
            if (!usedSecret[j] && guessArr[i] === secretArr[j]) {
                misplaced++;
                usedSecret[j] = true;
                break;
            }
        }
    }

    return { matches, misplaced };
}

function submitGuess() {
    if (!gameActive) return;

    const input = document.getElementById('guessInput');
    const err = document.getElementById('guessError');
    const guess = input.value.trim().toUpperCase();

    err.textContent = '';

    if (guess.length !== wordLen) {
        err.textContent = `Enter exactly ${wordLen} letters.`;
        return;
    }

    if (!/^[A-Z]+$/.test(guess)) {
        err.textContent = 'Letters only please.';
        return;
    }

    attempts++;
    score = Math.max(0, score - 5);
    updateScore();

    const result = evaluateGuess(guess, secretWord);

    addHistoryEntry(guess, result);

    input.value = '';

    if (result.matches === wordLen) {
        endGame(true);
    } else if (score === 0) {
        endGame(false);
    } else {
        startTimer();
    }
}

function addHistoryEntry(guess, result) {
    const list = document.getElementById('historyList');
    const entry = document.createElement('div');

    entry.className = 'guess-entry';

    const tiles = guess.split('').map(char =>
        `<div class="tile">${char}</div>`
    ).join('');

    let feedback = '';

    if (result.matches > 0) {
        feedback += `MATCH: ${result.matches}`;
    }

    if (result.misplaced > 0) {
        if (feedback) feedback += ' | ';
        feedback += `MISPLACED: ${result.misplaced}`;
    }

    if (result.matches === 0 && result.misplaced === 0) {
        feedback = 'ABSENT';
    }

    entry.innerHTML = `
        <span class="guess-num">#${attempts}</span>
        <div class="letter-tiles">${tiles}</div>
        <div class="guess-result">${feedback}</div>
    `;

    list.prepend(entry);
}

function endGame(won) {
    gameActive = false;
    clearInterval(timerInterval);

    document.getElementById('guessRow').classList.add('hidden');

    const card = document.getElementById('resultCard');
    card.classList.remove('hidden');

    if (won) {
        card.innerHTML = `
            <div class="result-title">Reasoning Sequence Solved</div>
            <div class="result-sub">Pattern successfully decoded.</div>
            <div class="result-word">${secretWord}</div>
            <button class="btn-primary" onclick="location.reload()">NEW SESSION</button>
        `;
    } else {
        card.innerHTML = `
            <div class="result-title">Inference Complete</div>
            <div class="result-sub">Target sequence remained unresolved.</div>
            <div class="result-word">${secretWord}</div>
            <button class="btn-primary" onclick="location.reload()">RETRY</button>
        `;
    }
}

document.addEventListener('keydown', function(e) {
    if (e.key === 'Enter') {
        submitGuess();
    }
});