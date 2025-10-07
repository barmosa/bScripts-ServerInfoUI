let seconds = 0;

function formatTime(totalSeconds) {
    const hours = Math.floor(totalSeconds / 3600);
    const minutes = Math.floor((totalSeconds % 3600) / 60);
    const seconds = totalSeconds % 60;

    if (hours > 0) {
        return `${hours}h ${minutes}m ${seconds}s`;
    } else if (minutes > 0) {
        return `${minutes}m ${seconds}s`;
    } else {
        return `${seconds}s`;
    }
}

function updateTimer() {
    seconds++;
    document.querySelector('.playtime-counter').textContent = formatTime(seconds);
}

setInterval(updateTimer, 1000);

window.addEventListener('message', function(event) {
    let data = event.data;
    if (data && data.type === "UPDATE_UI") {
        const payload = data.data || {};

        const colors = payload.colors || {};
        const rootStyle = document.documentElement && document.documentElement.style;
        if (rootStyle) {
            if (colors.ServerNameColor) rootStyle.setProperty('--server-name-color', String(colors.ServerNameColor));
            if (colors.LabelColor) rootStyle.setProperty('--label-color', String(colors.LabelColor));
        }

        const idEl = document.getElementById('hud-id');
        if (idEl && (payload.id !== undefined && payload.id !== null)) {
            idEl.textContent = String(payload.id);
        }

        const playersEl = document.getElementById('hud-players');
        if (playersEl && payload.players !== undefined && payload.maxPlayers !== undefined) {
            playersEl.textContent = ` - ${payload.players}/${payload.maxPlayers}`;
        }

        const serverNameEl = document.getElementById('hud-servername');
        if (serverNameEl && payload.serverName) {
            serverNameEl.textContent = String(payload.serverName);
        }

        const jobObj = payload.job || {};
        const jobGradeObj = (jobObj.grade || {});
        const jobLabel =
            payload.jobGradeLabel || payload.job_grade_label ||
            jobGradeObj.label || jobGradeObj.name ||
            payload.jobLabel || payload.job_label || jobObj.label || jobObj.name ||
            payload.jobName || payload.job;
        const jobEl = document.getElementById('hud-job');
        if (jobEl && jobLabel !== undefined && jobLabel !== null) {
            jobEl.textContent = String(jobLabel);
        }
    }
});
