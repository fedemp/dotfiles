return {
	settings = {
		tailwindCSS = {
			classAttributes = {
				"class",
				"className",
			},
			experimental = {
				classRegex = {
					{ "cx\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },
					{ "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
					{ "cx\\(.*?\\)(?!\\])", "(?:'|\"|`)([^\"'`]*)(?:'|\"|`)" },
				},
			},
			validate = true,
		},
	},
}
