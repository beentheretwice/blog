/**
 * Language Preference Manager
 * 
 * Features:
 * - Detects browser language on first visit
 * - Stores user preference in localStorage
 * - Redirects to preferred language
 * - Respects user manual language switches
 */

(function() {
    'use strict';
    
    const STORAGE_KEY = 'waqtsalat-lang-preference';
    const SUPPORTED_LANGS = ['ar', 'en', 'fr'];
    const DEFAULT_LANG = 'ar';
    
    /**
     * Get browser language
     * Returns the first supported language found, or default
     */
    function getBrowserLanguage() {
        const browserLang = navigator.language || navigator.userLanguage;
        if (!browserLang) return DEFAULT_LANG;
        
        // Get the primary language code (e.g., 'en-US' -> 'en')
        const primaryLang = browserLang.split('-')[0].toLowerCase();
        
        // Check if it's supported
        if (SUPPORTED_LANGS.includes(primaryLang)) {
            return primaryLang;
        }
        
        // Check if browser language starts with any supported language
        for (const lang of SUPPORTED_LANGS) {
            if (browserLang.toLowerCase().startsWith(lang)) {
                return lang;
            }
        }
        
        return DEFAULT_LANG;
    }
    
    /**
     * Get stored language preference
     */
    function getStoredPreference() {
        try {
            return localStorage.getItem(STORAGE_KEY);
        } catch (e) {
            console.warn('localStorage not available:', e);
            return null;
        }
    }
    
    /**
     * Store language preference
     */
    function storePreference(lang) {
        try {
            localStorage.setItem(STORAGE_KEY, lang);
        } catch (e) {
            console.warn('Could not store preference:', e);
        }
    }
    
    /**
     * Get current path language
     */
    function getCurrentLanguage() {
        const path = window.location.pathname;
        const match = path.match(/\/blog\/(ar|en|fr)(\/|$)/);
        return match ? match[1] : null;
    }
    
    /**
     * Redirect to language path
     */
    function redirectToLanguage(lang) {
        const currentLang = getCurrentLanguage();
        
        // Don't redirect if already on the correct language
        if (currentLang === lang) return;
        
        // Don't redirect if user is on a specific page (not homepage)
        // This prevents redirecting when user manually navigated
        if (currentLang && currentLang !== lang) {
            // User manually switched, store this preference
            storePreference(currentLang);
            return;
        }
        
        // Build new URL
        const baseUrl = '/blog/';
        let newPath;
        
        if (lang === DEFAULT_LANG) {
            // For default language, go to root
            newPath = baseUrl;
        } else {
            newPath = baseUrl + lang + '/';
        }
        
        // Preserve hash and query params
        newPath += window.location.hash;
        
        // Redirect
        window.location.replace(newPath);
    }
    
    /**
     * Initialize language detection
     */
    function init() {
        // Check if user has a stored preference
        const storedLang = getStoredPreference();
        
        if (storedLang) {
            // User has a preference, use it
            redirectToLanguage(storedLang);
        } else {
            // No preference stored, detect from browser
            const browserLang = getBrowserLanguage();
            storePreference(browserLang);
            redirectToLanguage(browserLang);
        }
    }
    
    /**
     * Set up language switcher listeners
     */
    function setupLanguageSwitcher() {
        const langLinks = document.querySelectorAll('.lang-switch a');
        
        langLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                const href = this.getAttribute('href');
                const match = href.match(/\/(ar|en|fr)\/?$/);
                
                if (match) {
                    // Store the selected language
                    storePreference(match[1]);
                }
            });
        });
    }
    
    // Run initialization
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            init();
            setupLanguageSwitcher();
        });
    } else {
        init();
        setupLanguageSwitcher();
    }
})();
