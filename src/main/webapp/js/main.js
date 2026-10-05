/**
 * SkillForge - Main UI Script
 */

document.addEventListener('DOMContentLoaded', () => {
    // Mobile navigation toggle
    const menuBtn = document.querySelector('.mobile-menu-btn');
    const navLinks = document.querySelector('.nav-links');

    if (menuBtn && navLinks) {
        menuBtn.addEventListener('click', () => {
            navLinks.classList.toggle('active');
        });
    }

    // User Dropdown toggle
    const userDropdown = document.getElementById('navUserDropdown');
    const userBtn = document.getElementById('navUserBtn');
    if (userDropdown && userBtn) {
        userBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            const isOpen = userDropdown.classList.toggle('open');
            userBtn.setAttribute('aria-expanded', isOpen);
        });

        document.addEventListener('click', (e) => {
            if (!userDropdown.contains(e.target)) {
                userDropdown.classList.remove('open');
                userBtn.setAttribute('aria-expanded', 'false');
            }
        });
    }

    // Auto-dismiss alerts or URL message toasts
    const urlParams = new URLSearchParams(window.location.search);
    const msg = urlParams.get('msg');
    const err = urlParams.get('error');

    if (msg) {
        const messageMap = {
            'logged_out': 'You have been successfully logged out.',
            'order_placed': 'Order placed successfully! Mock payment received.',
            'order_success': 'Payment verified and order initiated successfully!',
            'status_updated': 'Order status updated successfully.',
            'service_created': 'New service posted successfully!',
            'service_updated': 'Service details updated successfully.',
            'service_deleted': 'Service removed successfully.',
            'review_added': 'Thank you! Your review and rating have been posted.',
            'already_reviewed': 'You have already submitted a review for this order.',
            'profile_updated': 'Profile details saved successfully.',
            'status_changed': 'User status updated successfully.'
        };
        const toastText = messageMap[msg] || msg;
        showToast(toastText, 'success');
    }

    if (err) {
        showToast(decodeURIComponent(err), 'error');
    }
});

/**
 * Toast Notification Helper
 */
function showToast(message, type = 'info') {
    let container = document.querySelector('.toast-container');
    if (!container) {
        container = document.createElement('div');
        container.className = 'toast-container';
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    
    let icon = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>`;
    if (type === 'success') {
        icon = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>`;
    } else if (type === 'error') {
        icon = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>`;
    } else if (type === 'warning') {
        icon = `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>`;
    }

    toast.innerHTML = `
        <span style="display: flex; align-items: center; justify-content: center;">${icon}</span>
        <div style="flex: 1; font-weight: 500; font-size: 0.9rem;">${message}</div>
    `;

    container.appendChild(toast);

    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(100%)';
        toast.style.transition = 'all 0.3s ease';
        setTimeout(() => toast.remove(), 300);
    }, 4000);
}
