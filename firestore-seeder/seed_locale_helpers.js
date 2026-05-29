const SUPPORTED_CONTENT_LOCALES = ['en-IN', 'ar-IN', 'mr-IN', 'ur-IN'];

function buildLocalizedFields({ title, description, translations = {} }) {
    const localized = {};
    for (const locale of SUPPORTED_CONTENT_LOCALES) {
        const translated = translations[locale] || {};
        localized[locale] = {
            title: translated.title || title,
            description: translated.description || description || '',
        };
    }
    return localized;
}

function buildLocalizedSubjectFields({ name, description, subtitle, badgeText, translations = {} }) {
    const localized = {};
    for (const locale of SUPPORTED_CONTENT_LOCALES) {
        const translated = translations[locale] || {};
        localized[locale] = {
            name: translated.name || name,
            description: translated.description || description || '',
            subtitle: translated.subtitle || subtitle || '',
            badgeText: translated.badgeText || badgeText || '',
        };
    }
    return localized;
}

function buildLocalizedChapterFields({ name, subtitle, translations = {} }) {
    const localized = {};
    for (const locale of SUPPORTED_CONTENT_LOCALES) {
        const translated = translations[locale] || {};
        localized[locale] = {
            name: translated.name || name,
            subtitle: translated.subtitle || subtitle || '',
        };
    }
    return localized;
}

function buildLocalizedBannerFields({ title, translations = {} }) {
    const localized = {};
    for (const locale of SUPPORTED_CONTENT_LOCALES) {
        const translated = translations[locale] || {};
        localized[locale] = {
            title: translated.title || title,
        };
    }
    return localized;
}

function buildLocalizedAnnouncementFields({ title, message, translations = {} }) {
    const localized = {};
    for (const locale of SUPPORTED_CONTENT_LOCALES) {
        const translated = translations[locale] || {};
        localized[locale] = {
            title: translated.title || title,
            message: translated.message || message,
        };
    }
    return localized;
}

module.exports = {
    SUPPORTED_CONTENT_LOCALES,
    buildLocalizedFields,
    buildLocalizedSubjectFields,
    buildLocalizedChapterFields,
    buildLocalizedBannerFields,
    buildLocalizedAnnouncementFields,
};