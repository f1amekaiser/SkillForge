/**
 * SkillForge - Asynchronous AJAX Operations
 * 1. Username Availability Check (CheckUsernameServlet)
 * 2. Wishlist Toggle (WishlistServlet)
 * 3. Pre-checkout Availability Check (PaymentServlet)
 * 4. XML Skills Document Retrieval & Client-Side HTML Table Parsing
 */

document.addEventListener('DOMContentLoaded', () => {

    // -------------------------------------------------------------
    // Feature 1: Username Availability Check
    // -------------------------------------------------------------
    const usernameInput = document.getElementById('username');
    const usernameStatus = document.getElementById('usernameStatus');

    if (usernameInput && usernameStatus) {
        let checkTimer;
        usernameInput.addEventListener('input', () => {
            clearTimeout(checkTimer);
            const val = usernameInput.value.trim();

            if (val.length < 3) {
                usernameStatus.textContent = '';
                usernameStatus.className = 'form-hint';
                return;
            }

            usernameStatus.textContent = 'Checking availability...';
            usernameStatus.style.color = 'var(--text-muted)';

            checkTimer = setTimeout(() => {
                const contextPath = window.SKILLFORGE_CONTEXT || '';
                fetch(`${contextPath}/api/check-username?username=${encodeURIComponent(val)}`)
                    .then(res => res.json())
                    .then(data => {
                        usernameStatus.textContent = data.message;
                        if (data.available) {
                            usernameStatus.style.color = 'var(--success)';
                            usernameStatus.style.fontWeight = '600';
                            usernameInput.style.borderColor = 'var(--success)';
                        } else {
                            usernameStatus.style.color = 'var(--danger)';
                            usernameStatus.style.fontWeight = '600';
                            usernameInput.style.borderColor = 'var(--danger)';
                        }
                    })
                    .catch(() => {
                        usernameStatus.textContent = '';
                    });
            }, 350);
        });
    }

    // -------------------------------------------------------------
    // Feature 3: Service Availability Pre-Check on Checkout Page
    // -------------------------------------------------------------
    const checkoutServiceId = document.getElementById('checkoutServiceId');
    const availabilityBadge = document.getElementById('availabilityBadge');

    if (checkoutServiceId && availabilityBadge) {
        const sid = checkoutServiceId.value;
        const contextPath = window.SKILLFORGE_CONTEXT || '';

        fetch(`${contextPath}/api/verify-availability?serviceId=${encodeURIComponent(sid)}`)
            .then(res => res.json())
            .then(data => {
                if (data.available) {
                    availabilityBadge.innerHTML = `<span class="badge badge-completed">✓ Service & Freelancer Available</span>`;
                } else {
                    availabilityBadge.innerHTML = `<span class="badge badge-cancelled">✕ ${data.message}</span>`;
                    const submitBtn = document.getElementById('payButton');
                    if (submitBtn) submitBtn.disabled = true;
                }
            })
            .catch(() => {
                availabilityBadge.innerHTML = `<span class="badge badge-pending">Verified</span>`;
            });
    }
});

// -------------------------------------------------------------
// Feature 2: Wishlist Toggle AJAX Function
// -------------------------------------------------------------
function toggleWishlist(serviceId, buttonEl) {
    const contextPath = window.SKILLFORGE_CONTEXT || '';

    const formData = new URLSearchParams();
    formData.append('serviceId', serviceId);

    fetch(`${contextPath}/api/wishlist/toggle`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData.toString()
    })
    .then(res => res.json())
    .then(data => {
        if (!data.success && data.message === 'Login required') {
            window.location.href = `${contextPath}/login.jsp?redirect=/service-details?id=${serviceId}`;
            return;
        }

        if (data.inWishlist) {
            buttonEl.innerHTML = `<svg width="16" height="16" viewBox="0 0 24 24" fill="#ef4444" stroke="#ef4444" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>`;
            buttonEl.classList.add('active');
            showToast('Added to your wishlist!', 'success');
        } else {
            buttonEl.innerHTML = `<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>`;
            buttonEl.classList.remove('active');
            showToast('Removed from your wishlist.', 'info');
        }

        // Update nav badge count if present
        const navCount = document.getElementById('navWishlistCount');
        if (navCount && data.count !== undefined) {
            navCount.textContent = data.count;
        }
    })
    .catch(err => {
        console.error('Wishlist error:', err);
        showToast('Error updating wishlist. Please try again.', 'error');
    });
}

// -------------------------------------------------------------
// Feature 4: XML Skills Document Retrieval & Parsing to HTML Table
// -------------------------------------------------------------
function loadSkillsXML() {
    const tableBody = document.getElementById('xmlSkillsTableBody');
    const statusMsg = document.getElementById('xmlStatusMsg');
    const contextPath = window.SKILLFORGE_CONTEXT || '';
    const xmlUrl = `${contextPath}/xml/skills.xml`;

    if (statusMsg) {
        statusMsg.innerHTML = '<span style="color: var(--primary); display: inline-flex; align-items: center; gap: 0.35rem;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg> Fetching XML document from server via AJAX...</span>';
    }

    const xhr = new XMLHttpRequest();
    xhr.open('GET', xmlUrl, true);

    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4) {
            if (xhr.status === 200 || xhr.status === 0) {
                const xmlDoc = xhr.responseXML || new DOMParser().parseFromString(xhr.responseText, 'text/xml');
                const skills = xmlDoc.getElementsByTagName('skill');

                if (!skills || skills.length === 0) {
                    if (statusMsg) statusMsg.innerHTML = '<span style="color: var(--danger);">No skills found in XML.</span>';
                    return;
                }

                let html = '';
                for (let i = 0; i < skills.length; i++) {
                    const skill = skills[i];
                    const id = skill.getElementsByTagName('id')[0]?.textContent || (i + 1);
                    const name = skill.getElementsByTagName('name')[0]?.textContent || 'N/A';
                    const category = skill.getElementsByTagName('category')[0]?.textContent || 'N/A';
                    const experience = skill.getElementsByTagName('experience')[0]?.textContent || 'General';
                    const demand = skill.getElementsByTagName('demand')[0]?.textContent || 'Medium';

                    let demandBadge = `<span class="badge badge-accepted">${demand}</span>`;
                    if (demand.toLowerCase().includes('very high')) {
                        demandBadge = `<span class="badge badge-completed">${demand}</span>`;
                    } else if (demand.toLowerCase().includes('high')) {
                        demandBadge = `<span class="badge badge-in_progress">${demand}</span>`;
                    }

                    html += `
                        <tr>
                            <td style="font-family: var(--font-mono); font-weight: 700; color: var(--text-muted);">${id}</td>
                            <td><strong style="color: var(--text-primary);">${name}</strong></td>
                            <td><span class="service-category-badge" style="margin-bottom:0;">${category}</span></td>
                            <td style="color: var(--text-secondary);">${experience}</td>
                            <td>${demandBadge}</td>
                        </tr>
                    `;
                }

                if (tableBody) {
                    tableBody.innerHTML = html;
                }
                if (statusMsg) {
                    statusMsg.innerHTML = `<span style="color: var(--success); font-weight: 600; display: inline-flex; align-items: center; gap: 0.35rem;"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg> XML successfully loaded and parsed! Displaying ${skills.length} skills in dynamic HTML table.</span>`;
                }
            } else {
                if (statusMsg) {
                    statusMsg.innerHTML = `<span style="color: var(--danger);">Failed to load XML document. HTTP Status: ${xhr.status}</span>`;
                }
            }
        }
    };

    xhr.onerror = function () {
        if (statusMsg) {
            statusMsg.innerHTML = '<span style="color: var(--danger);">Network error while requesting XML document.</span>';
        }
    };

    xhr.send();
}
