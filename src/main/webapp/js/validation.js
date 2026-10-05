/**
 * SkillForge - Client-Side Form Validations & Password Strength Indicator
 */

document.addEventListener('DOMContentLoaded', () => {

    // -------------------------------------------------------------
    // 1. Password Strength Indicator
    // -------------------------------------------------------------
    const passwordInput = document.getElementById('regPassword');
    const strengthBar = document.getElementById('passwordStrengthBar');
    const strengthLabel = document.getElementById('passwordStrengthLabel');

    if (passwordInput && strengthBar && strengthLabel) {
        passwordInput.addEventListener('input', () => {
            const pwd = passwordInput.value;
            const strength = calculatePasswordStrength(pwd);

            strengthBar.style.width = strength.percentage + '%';
            strengthBar.style.backgroundColor = strength.color;
            strengthLabel.textContent = strength.text;
            strengthLabel.style.color = strength.color;
        });
    }

    // -------------------------------------------------------------
    // 2. Character Counters
    // -------------------------------------------------------------
    document.querySelectorAll('[data-char-counter]').forEach(textarea => {
        const targetCounterId = textarea.getAttribute('data-char-counter');
        const counterEl = document.getElementById(targetCounterId);
        const maxLen = textarea.getAttribute('maxlength') || 500;

        if (counterEl) {
            const updateCount = () => {
                const current = textarea.value.length;
                counterEl.textContent = `${current} / ${maxLen}`;
            };
            textarea.addEventListener('input', updateCount);
            updateCount();
        }
    });

    // -------------------------------------------------------------
    // 3. Registration Form Client-Side Validation
    // -------------------------------------------------------------
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', (e) => {
            let isValid = true;

            const name = document.getElementById('name');
            const username = document.getElementById('username');
            const email = document.getElementById('email');
            const password = document.getElementById('regPassword');
            const confirmPassword = document.getElementById('confirmPassword');

            clearErrors(registerForm);

            // Name validation
            if (!name.value.trim()) {
                showFieldError(name, 'Full name is required.');
                isValid = false;
            }

            // Username validation
            if (!username.value.trim() || username.value.trim().length < 3) {
                showFieldError(username, 'Username must be at least 3 characters long.');
                isValid = false;
            }

            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!email.value.trim() || !emailRegex.test(email.value.trim())) {
                showFieldError(email, 'Please enter a valid email address.');
                isValid = false;
            }

            // Password validation
            if (!password.value || password.value.length < 6) {
                showFieldError(password, 'Password must be at least 6 characters long.');
                isValid = false;
            }

            // Confirm Password validation
            if (password.value !== confirmPassword.value) {
                showFieldError(confirmPassword, 'Passwords do not match.');
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
                showToast('Please fix the errors highlighted in the form.', 'error');
            }
        });
    }

    // -------------------------------------------------------------
    // 4. Service Form Validation (Price, Delivery Days)
    // -------------------------------------------------------------
    const serviceForm = document.getElementById('serviceForm');
    if (serviceForm) {
        serviceForm.addEventListener('submit', (e) => {
            let isValid = true;
            clearErrors(serviceForm);

            const title = document.getElementById('title');
            const price = document.getElementById('price');
            const deliveryDays = document.getElementById('deliveryDays');
            const description = document.getElementById('description');

            if (title && !title.value.trim()) {
                showFieldError(title, 'Service title is required.');
                isValid = false;
            }

            if (price) {
                const pVal = parseFloat(price.value);
                if (isNaN(pVal) || pVal <= 0) {
                    showFieldError(price, 'Price must be a valid number greater than 0.');
                    isValid = false;
                }
            }

            if (deliveryDays) {
                const dVal = parseInt(deliveryDays.value, 10);
                if (isNaN(dVal) || dVal <= 0) {
                    showFieldError(deliveryDays, 'Delivery days must be at least 1.');
                    isValid = false;
                }
            }

            if (description && description.value.trim().length < 20) {
                showFieldError(description, 'Please describe your service in at least 20 characters.');
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
                showToast('Please correct form errors before saving.', 'error');
            }
        });
    }
});

function calculatePasswordStrength(password) {
    if (!password) {
        return { percentage: 0, color: '#e2e8f0', text: '' };
    }

    let score = 0;
    if (password.length >= 6) score += 20;
    if (password.length >= 10) score += 20;
    if (/[A-Z]/.test(password)) score += 20;
    if (/[0-9]/.test(password)) score += 20;
    if (/[^A-Za-z0-9]/.test(password)) score += 20;

    if (score <= 40) {
        return { percentage: 33, color: '#ef4444', text: 'Weak password' };
    } else if (score <= 60) {
        return { percentage: 66, color: '#f59e0b', text: 'Medium password' };
    } else {
        return { percentage: 100, color: '#10b981', text: 'Strong password' };
    }
}

function showFieldError(inputEl, message) {
    inputEl.style.borderColor = 'var(--danger)';
    let errorEl = inputEl.parentElement.querySelector('.form-error');
    if (!errorEl) {
        errorEl = document.createElement('span');
        errorEl.className = 'form-error';
        inputEl.parentElement.appendChild(errorEl);
    }
    errorEl.textContent = message;
}

function clearErrors(formEl) {
    formEl.querySelectorAll('.form-control, .form-select').forEach(el => {
        el.style.borderColor = '';
    });
    formEl.querySelectorAll('.form-error').forEach(el => el.remove());
}
