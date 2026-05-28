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

module.exports = {
    SUPPORTED_CONTENT_LOCALES,
    buildLocalizedFields,
};