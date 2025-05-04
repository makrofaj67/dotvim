-- lua/plugins/lsp.lua (veya benzeri)

return {
	-- LSP Yapılandırması
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" }, -- LSP'yi dosya açıldığında yükle
		dependencies = {
			-- Temel araçlar: Mason ve köprüleri
			{ "williamboman/mason.nvim", opts = {} }, -- Mason'u önce yükle
			"williamboman/mason-lspconfig.nvim",    -- Mason ve lspconfig köprüsü
			"WhoIsSethDaniel/mason-tool-installer.nvim", -- Araçları otomatik kurar

			-- Kullanıcı Arayüzü ve Yardımcılar
			{ "j-hui/fidget.nvim", tag = "legacy", opts = {} }, -- LSP ilerleme durumu UI (legacy tag'ı gerekebilir)
			-- { "folke/neodev.nvim", opts = {} }, -- Neovim Lua geliştirmesi için (isteğe bağlı, lua_ls ile de çalışır)

			-- Tamamlama Kaynağı (nvim-cmp kullanıyorsanız)
			"hrsh7th/cmp-nvim-lsp",

			-- Diğer LSP ile ilgili eklentiler (isteğe bağlı)
			-- "folke/snacks.nvim", -- Kullanıyorsanız ve uyarı veriyorsa güncellemeyi deneyin
		},
		config = function()
		-- =========================================================================
		-- On Attach Fonksiyonu: LSP sunucusu tampona bağlandığında çalışır
		-- =========================================================================
		local on_attach = function(client, bufnr)
		-- Yerel anahtar eşlemeleri ayarlamak için yardımcı fonksiyon
	-- Temel LSP işlevleri için anahtar eşlemeleri

		-- İmleç altındaki sembolün kullanımını vurgulama
		-- DÜZELTME: client:supports_method (iki nokta üst üste) kullanıldı
		if client:supports_method("textDocument/documentHighlight") then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = bufnr,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
				desc = "LSP Highlight References"
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = bufnr,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
				desc = "LSP Clear References"
			})
			-- Not: LspDetach içinde temizleme global autocmd'de yapılıyor.
			end

			-- Inlay hints (ipuçları)
			-- DÜZELTME: client:supports_method (iki nokta üst üste) kullanıldı


				-- İsteğe bağlı: Formatlama (eğer formatlayıcı yapılandırıldıysa ve sunucu destekliyorsa)
				-- if client:supports_method("textDocument/formatting") then
				--   map("<leader>f", function() vim.lsp.buf.format({ async = true }) end, "[F]ormat Document")
				-- end

				-- İstemcinin başarıyla bağlandığını bildir (opsiyonel)
				-- print("LSP client attached: " .. client.name .. " to buffer " .. bufnr)
				vim.notify("LSP client attached: " .. client.name, vim.log.levels.INFO)
				end

				-- =========================================================================
				-- LSP İstemci Yetenekleri (Capabilities)
				-- =========================================================================
				-- Temel yetenekleri al
				local capabilities = vim.lsp.protocol.make_client_capabilities()
				-- nvim-cmp için LSP yeteneklerini ekle
				capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
				-- Inlay Hints için yetenek ekle (bazı sunucular için gerekli olabilir)
				capabilities.textDocument.inlayHint = { dynamicRegistration = false }
				capabilities.textDocument.publishDiagnostics = { relatedInformation = true }


				-- =========================================================================
				-- Yönetilecek Sunucular ve Özel Ayarları
				-- =========================================================================
				local servers = {
					-- Lua (Neovim yapılandırması için)
					lua_ls = {
						settings = {
							Lua = {
								completion = { callSnippet = "Replace" },
								telemetry = { enable = false },
								diagnostics = {
									globals = { 'vim' }, -- 'vim' globalini tanıt
									-- Kullanılmayan değişkenleri vb. kapatmak isterseniz:
									-- disable = { "unused-local", "unused-function" }
								},
								workspace = {
									checkThirdParty = false, -- 'require' için dış kütüphane uyarılarını kapatabilir
								}
							},
						},
					},
					-- C/C++
					clangd = {
						-- Özel clangd ayarları buraya eklenebilir.
						-- Ancak derleme bayrakları (include yolları vb.) için
						-- projenizde 'compile_commands.json' dosyası oluşturmanız ŞİDDETLE önerilir.
						-- CMake: cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
						-- Mason: make compiledb
						-- Bear: bear -- <build command>
						filetypes = {"c", "cpp", "h", "hpp", "objc", "objcpp"},
						root_dir = function(fname)
							-- Git reposunu, Makefile ve diğer proje dosyalarını otomatik olarak tespit et
							local util = require("lspconfig.util")
							return util.root_pattern("Makefile", ".git", "compile_commands.json", "compile_flags.txt")(fname) or
								util.find_git_ancestor(fname) or
								util.path.dirname(fname)
						end,
						-- Eğer compile_commands.json bulunmuyorsa otomatik oluşturmayı dene
						on_new_config = function(new_config, new_root_dir)
							-- Özel komutlar eklenebilir
							if vim.fn.filereadable(new_root_dir .. "/compile_commands.json") == 0 and
							   vim.fn.filereadable(new_root_dir .. "/Makefile") == 1 then
								-- compile_commands.json yoksa ve Makefile varsa, bear ile oluşturmayı dene
								vim.notify("clangd: compile_commands.json bulunamadı, oluşturmayı deneyin. Örneğin:\n" ..
									"   cd " .. new_root_dir .. " && bear -- make", vim.log.levels.WARN)
							end
						end,
						init_options = {
							clangdFileStatus = true,
							completeUnimported = true,
							semanticHighlighting = true,
						},
						cmd = {"clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu"},
					},
					-- C#
					omnisharp = {
						-- cmd = {"path/to/OmniSharp.exe", "-lsp"} -- Eğer Mason'un bulamadığı özel bir kurulum varsa
						-- Özel OmniSharp ayarları eklenebilir, örn:
						-- enable_roslyn_analyzers = true,
						-- enable_import_completion = true,
					},
					-- Python (örnek)
					-- pyright = {},
					-- Typescript/Javascript (örnek)
					-- tsserver = {},
					-- Go (örnek)
					-- gopls = {},
					-- Rust (örnek)
					-- rust_analyzer = {
					--	['rust-analyzer'] = { -- Ayarlar rust-analyzer anahtarı altına gruplanır
					--		check = { command = "clippy" }
					--	}
					--},
				}

				-- =========================================================================
				-- Mason Kurulumu: LSP Sunucuları ve Diğer Araçlar
				-- =========================================================================
				-- Kurulması gereken araçların listesi
				local ensure_installed = vim.tbl_keys(servers) -- `servers` tablosundaki tüm LSP sunucularını al
				-- Ekstra araçları (formatlayıcılar, linterlar vb.) ekle
				vim.list_extend(ensure_installed, {
					"stylua",        -- Lua formatlayıcı
					-- "clang-format", -- C/C++ formatlayıcı (isteğe bağlı)
				-- "csharpier",   -- C# formatlayıcı (isteğe bağlı)
				-- "isort",       -- Python import sıralayıcı (isteğe bağlı)
				-- "black",       -- Python formatlayıcı (isteğe bağlı)
				-- "prettier",    -- Web formatlayıcı (isteğe bağlı)
				})

				-- mason-tool-installer'ı ayarla
				require("mason-tool-installer").setup({
					ensure_installed = ensure_installed,
					auto_update = false, -- Sunucuları otomatik güncellemek isterseniz 'true' yapın
					run_on_start = true, -- Neovim başlangıcında eksik araçları kur
				})

				-- =========================================================================
				-- Mason-Lspconfig Köprüsü: Sunucuları Yapılandır
				-- =========================================================================
				require("mason-lspconfig").setup({
					-- ensure_installed = ensure_installed, -- tool-installer'da zaten yapıldı
					handlers = {
						-- Varsayılan handler: Tüm sunucular için bu fonksiyon çalışır
						function(server_name)
						local server_opts = servers[server_name] or {} -- Özel sunucu ayarlarını al

						-- Her sunucu için genel ayarları (on_attach, capabilities) ekle
						server_opts.on_attach = on_attach
						server_opts.capabilities = capabilities

						-- lspconfig ile sunucuyu kur
						require("lspconfig")[server_name].setup(server_opts)
						end,

						-- İsterseniz belirli sunucular için özel handler'lar tanımlayabilirsiniz
						-- ["clangd"] = function()
				--	 local server_opts = servers.clangd
				--	 server_opts.on_attach = on_attach
				--	 server_opts.capabilities = capabilities
				--	 -- Belki clangd için ekstra bir şey yapmak istersiniz...
				--	 require("lspconfig").clangd.setup(server_opts)
				-- end,
					},
				})

				-- =========================================================================
				-- Tanıtlama (Diagnostics) Görünüm Ayarları
				-- =========================================================================
				-- DÜZELTME: Tanıtlama işaretleri doğrudan vim.diagnostic.config içinde tanımlandı
				vim.diagnostic.config({
					virtual_text = { -- Satır içi hataları göster (opsiyonel)
						source = "always", -- Hangi kaynaktan geldiğini göster (örn. "LuaLS")
				prefix = '●', -- Hata mesajının başındaki ikon
					},
					signs = { -- Kenar çubuğundaki işaretler
						active = true, -- İşaretleri etkinleştir
						-- Özel ikonlar (Nerd Font gerektirebilir)
				text = {
					[vim.diagnostic.severity.ERROR] = vim.fn.has("nvim-0.10") and "󰅚" or "E", -- Error
					[vim.diagnostic.severity.WARN] = vim.fn.has("nvim-0.10") and "󰀪" or "W",  -- Warn
					[vim.diagnostic.severity.INFO] = vim.fn.has("nvim-0.10") and "󰋽" or "I",  -- Info
					[vim.diagnostic.severity.HINT] = vim.fn.has("nvim-0.10") and "󰌶" or "H",  -- Hint
				},
					},
					underline = true,          -- Hatalı kodun altını çiz
					update_in_insert = false,  -- Insert modunda güncellemeyi kapat (performans)
				severity_sort = true,      -- Hataları önem sırasına göre sırala
				float = { -- Hata penceresinin görünümü
					source = "always", -- Kaynağı göster
					border = "rounded",
					header = "",
					prefix = "",
				},
				})

				-- Tanımlama penceresi (float) için stil ayarları (isteğe bağlı)
				vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
				vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })


				-- =========================================================================
				-- Global Autocmds (LspDetach)
				-- =========================================================================
				-- LSP istemcisi bir tampondan ayrıldığında vurgulamayı temizle
				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
											callback = function(event)
											-- İlgili tampon için vurgulama autocmd'lerini temizle
											vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event.buf })
											-- print("LSP client detached from buffer: " .. event.buf) -- İsteğe bağlı loglama
											end,
											desc = "Clean up LSP highlight on detach"
				})

				print("LSP configuration loaded.") -- Yapılandırmanın yüklendiğini bildir (opsiyonel)

				end, -- config fonksiyonu sonu
	}, -- nvim-lspconfig plugin tanımı sonu

	-- ... diğer plugin tanımlamalarınız ...
}
