let extras = []

if (process.env.JEKYLL_ENV === "production")
  extras.push("../build/**/*.html")

module.exports = {
  content: [
    "**/*.html",
    "**/*.md",
    "**/*.markdown",
    ...extras
  ],
  theme: {
    extend: {},
  },
  plugins: [require("@tailwindcss/typography")],
}
