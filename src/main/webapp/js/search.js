/**
 * SkillForge - Live AJAX Search and Dynamic Marketplace Filters
 */

document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('marketplaceSearchInput');
    const categoryFilter = document.getElementById('categoryFilter');
    const minPriceInput = document.getElementById('minPriceInput');
    const maxPriceInput = document.getElementById('maxPriceInput');
    const ratingFilter = document.getElementById('ratingFilter');
    const deliveryFilter = document.getElementById('deliveryFilter');
    const sortSelect = document.getElementById('sortSelect');
    const servicesGrid = document.getElementById('servicesGrid');
    const searchStatus = document.getElementById('searchStatus');
    const resultCount = document.getElementById('resultCount');

    if (!servicesGrid) return;

    let debounceTimer;

    const performSearch = () => {
        if (searchStatus) {
            searchStatus.textContent = 'Searching...';
            searchStatus.style.display = 'block';
        }

        const params = new URLSearchParams();
        if (searchInput && searchInput.value.trim()) {
            params.append('q', searchInput.value.trim());
        }
        if (categoryFilter && categoryFilter.value) {
            params.append('categoryId', categoryFilter.value);
        }
        if (minPriceInput && minPriceInput.value) {
            params.append('minPrice', minPriceInput.value);
        }
        if (maxPriceInput && maxPriceInput.value) {
            params.append('maxPrice', maxPriceInput.value);
        }
        if (ratingFilter && ratingFilter.value) {
            params.append('minRating', ratingFilter.value);
        }
        if (deliveryFilter && deliveryFilter.value) {
            params.append('deliveryDays', deliveryFilter.value);
        }
        if (sortSelect && sortSelect.value) {
            params.append('sortBy', sortSelect.value);
        }

        const contextPath = window.SKILLFORGE_CONTEXT || '';
        fetch(`${contextPath}/api/search-services?${params.toString()}`)
            .then(res => {
                if (!res.ok) throw new Error('Search failed');
                return res.json();
            })
            .then(services => {
                if (searchStatus) searchStatus.style.display = 'none';
                renderServices(services, servicesGrid, contextPath);
                if (resultCount) {
                    resultCount.textContent = `${services.length} services found`;
                }
            })
            .catch(err => {
                console.error(err);
                if (searchStatus) {
                    searchStatus.textContent = 'Error loading services. Please try again.';
                }
            });
    };

    const triggerDebouncedSearch = () => {
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(performSearch, 300);
    };

    if (searchInput) searchInput.addEventListener('input', triggerDebouncedSearch);
    if (categoryFilter) categoryFilter.addEventListener('change', performSearch);
    if (minPriceInput) minPriceInput.addEventListener('input', triggerDebouncedSearch);
    if (maxPriceInput) maxPriceInput.addEventListener('input', triggerDebouncedSearch);
    if (ratingFilter) ratingFilter.addEventListener('change', performSearch);
    if (deliveryFilter) deliveryFilter.addEventListener('change', performSearch);
    if (sortSelect) sortSelect.addEventListener('change', performSearch);

    // Filter pill buttons if present
    document.querySelectorAll('.category-pill-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            document.querySelectorAll('.category-pill-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            const catId = btn.getAttribute('data-category-id');
            if (categoryFilter) {
                categoryFilter.value = catId || '';
            }
            performSearch();
        });
    });
});

function renderServices(services, container, contextPath) {
    if (!services || services.length === 0) {
        container.innerHTML = `
            <div style="grid-column: 1 / -1; text-align: center; padding: 4rem 1rem;">
                <div style="width: 56px; height: 56px; background: var(--bg-main); border-radius: var(--radius-full); display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem; color: var(--text-muted);">
                    <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                </div>
                <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 0.5rem;">No services match your criteria</h3>
                <p style="color: var(--text-secondary); max-width: 400px; margin: 0 auto 1.5rem;">
                    Try adjusting your search terms, removing filters, or browsing other categories.
                </p>
                <button class="btn btn-secondary" onclick="window.location.href='${contextPath}/services'">Reset All Filters</button>
            </div>
        `;
        return;
    }

    container.innerHTML = services.map(s => {
        const rating = s.rating ? Number(s.rating).toFixed(1) : '5.0';
        const reviewCount = s.reviewCount || 0;
        const price = s.price ? `₹${Number(s.price).toLocaleString('en-IN')}` : '₹0';
        const freelancerName = s.freelancerName || 'Freelancer';
        const freelancerInitial = freelancerName.charAt(0).toUpperCase();
        const categoryName = s.categoryName || 'Service';

        return `
            <div class="service-card">
                <div class="service-card-body">
                    <div class="service-freelancer">
                        <div class="user-avatar" style="width: 36px; height: 36px;">
                            ${freelancerInitial}
                        </div>
                        <div class="service-freelancer-info">
                            <h4><a href="${contextPath}/freelancer-profile?id=${s.freelancerId}">${escapeHtml(freelancerName)}</a></h4>
                            <span>@${escapeHtml(s.freelancerUsername || 'student')}</span>
                        </div>
                    </div>

                    <span class="service-category-badge">${escapeHtml(categoryName)}</span>
                    <h3 class="service-card-title">
                        <a href="${contextPath}/service-details?id=${s.id}">${escapeHtml(s.title)}</a>
                    </h3>
                    <p class="service-card-desc">${escapeHtml(s.description)}</p>

                    <div class="service-rating" style="display: flex; align-items: center; gap: 0.35rem;">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="#f59e0b" stroke="#f59e0b" stroke-width="1"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                        <span style="font-weight: 700; color: var(--text-primary);">${rating}</span>
                        <span class="count">(${reviewCount} reviews)</span>
                    </div>

                    <div style="font-size: 0.82rem; color: var(--text-muted); margin-bottom: 0.75rem; display: flex; align-items: center; gap: 0.35rem;">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        Delivery: <strong>${s.deliveryDays} ${s.deliveryDays === 1 ? 'day' : 'days'}</strong>
                    </div>
                </div>

                <div class="service-card-footer">
                    <div class="service-price-block">
                        <span class="service-price-label">Starting at</span>
                        <span class="service-price-val">${price}</span>
                    </div>
                    <div style="display: flex; gap: 0.5rem; align-items: center;">
                        <button class="wishlist-btn-heart" onclick="toggleWishlist(${s.id}, this)" title="Add to Wishlist" style="display: flex; align-items: center; justify-content: center;">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                        </button>
                        <a href="${contextPath}/service-details?id=${s.id}" class="btn btn-primary btn-sm">
                            View Service
                        </a>
                    </div>
                </div>
            </div>
        `;
    }).join('');
}

function escapeHtml(text) {
    if (!text) return '';
    const map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' };
    return text.replace(/[&<>"']/g, m => map[m]);
}
