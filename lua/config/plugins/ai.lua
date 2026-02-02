return {
  {
    "robitx/gp.nvim",
    config = function()
      -- Custom provider to handle the /v1/responses endpoint
      local custom_openai_handler = function(params, handler_opts)
        print("Params: " .. vim.inspect(params))
        local curl = require('plenary.curl')
        local json = vim.json

        -- Transform chat messages to a single prompt
        local prompt = ""
        if params.messages and #params.messages > 0 then
          for _, msg in ipairs(params.messages) do
            if msg.role == 'user' then
              prompt = prompt .. msg.content .. "\n"
            end
          end
        elseif params.prompt then
          prompt = params.prompt
        end
        print("Constructed prompt: " .. prompt)

        -- Build the request body from scratch to avoid passing unsupported params
        local request_body = {
          model = params.model,
          input = prompt,
        }

        -- Add optional parameters only if they exist
        if params.temperature then
          request_body.temperature = params.temperature
        end
        if params.max_tokens then
          request_body.max_tokens = params.max_tokens

        end
        print("Request body: " .. vim.inspect(request_body))

        local headers = {
          content_type = "application/json",
          authorization = "Bearer " .. os.getenv("OPENAI_API_KEY"),
        }

        curl.post(params.endpoint, {
          headers = headers,
          body = json.encode(request_body),
          callback = vim.schedule_wrap(function(response)
            if response.status >= 200 and response.status < 300 then
              local data = json.decode(response.body)
              local content = ""
              -- The Responses API might have a different response structure
              if data.output and data.output[1] and data.output[1].content then
                content = data.output[1].content[0].text
              elseif data.choices and #data.choices > 0 and data.choices[1].text then
                content = data.choices[1].text
              end
              handler_opts.on_result(content)
            else
              handler_opts.on_error(response.body)
            end
          end),
          on_error = vim.schedule_wrap(function(err)
            handler_opts.on_error(vim.inspect(err))
          end),
        })
      end

      local conf = {
        default_chat_agent = "GLM4.6",
        default_command_agent = "GLM4.6",
        providers = {
          custom_openai = {
            endpoint = "https://api.openai.com/v1/responses",
            secret = os.getenv("OPENAI_API_KEY"),
            -- Override the handler for this provider
            handler = custom_openai_handler,
          },
          anthropic = {
            endpoint = "https://api.anthropic.com/v1/messages",
            secret = os.getenv("CLAUDE_API_KEY"),
          },
          openrouter = {
            endpoint = "https://openrouter.ai/api/v1/chat/completions",
            secret = os.getenv("OPEN_ROUTER_API_KEY"),
          },
          grok = {
            endpoint = "https://api.x.ai/v1/chat/completions",
            secret = os.getenv("X_AI_KEY"),
          },
        },
        agents = {
          {
            name = "OPENAI",
            provider = "custom_openai",
            chat = true,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "gpt-5.1-codex-max", temperature = 0.1, top_p = 1 },
	    system_prompt = "You are an AI working as a code editor.\n\n"
                .. "before providing an answer, check the appropriate documentation.\n"
                .. "do not rely on your memory and always provide reference to the place you found the relevant info.\n"
                .. "then ask yourself - am I correct? reconsider your answer.\n"
                .. "present your answer only when you see no room for improvement.\n"
                .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
                .. "START AND END YOUR ANSWER WITH:\n\n```"
          },
          {
            name = "CLAUDE",
            provider = "anthropic",
            chat = true,
            command = true,
            model = { model = "claude-opus-4-5-20251101"},
	    system_prompt = "You are an AI working as a code editor.\n\n"
                .. "before providing an answer, check the appropriate documentation.\n"
                .. "do not rely on your memory and always provide reference to the place you found the relevant info.\n"
                .. "then ask yourself - am I correct? reconsider your answer.\n"
                .. "present your answer only when you see no room for improvement.\n"
                .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
                .. "START AND END YOUR ANSWER WITH:\n\n```"
          },
          {
            name = "OpenRouter",
            provider = "openrouter",
            chat = true,
            command = true,
            model = { model = "z-ai/glm-4.6",temperature = 0.1, top_p = 1  },
      system_prompt = "You are an AI working as a code editor.\n\n"
                .. "before providing an answer, check the appropriate documentation.\n"
                .. "do not rely on your memory and always provide reference to the place you found the relevant info.\n"
                .. "then ask yourself - am I correct? reconsider your answer.\n"
                .. "present your answer only when you see no room for improvement.\n"
                .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
                .. "START AND END YOUR ANSWER WITH:\n\n```"
          },
          {
            name = "GROK",
            provider = "grok",
            chat = true,
            command = true,
            model = { model = "grok-code-fast" },
      system_prompt = "You are an AI working as a code editor.\n\n"
                .. "before providing an answer, check the appropriate documentation.\n"
                .. "do not rely on your memory and always provide reference to the place you found the relevant info.\n"
                .. "then ask yourself - am I correct? reconsider your answer.\n"
                .. "present your answer only when you see no room for improvement.\n"
                .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
                .. "START AND END YOUR ANSWER WITH:\n\n```"
          },
        },
      }
      local defaults = require("gp.config")
      for _, agent in ipairs(defaults.agents) do
        table.insert(conf.agents, { name = agent.name, disable = true })
      end

      require("gp").setup(conf)

      -- Shortcuts
      local function keymapOptions(desc)
        return {
          noremap = true,
          silent = true,
          nowait = true,
          desc = "GPT prompt " .. desc,
        }
      end

      -- Chat commands
      vim.keymap.set({ "n", "i" }, "<C-g>c", "<cmd>GpChatNew<cr>", keymapOptions("New Chat"))
      vim.keymap.set({ "n", "i" }, "<C-g>t", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Chat"))
      vim.keymap.set({ "n", "i" }, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))

      vim.keymap.set("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions("Visual Chat New"))
      vim.keymap.set("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions("Visual Chat Paste"))
      vim.keymap.set("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions("Visual Toggle Chat"))

      -- Prompt commands
      vim.keymap.set({ "n", "i" }, "<C-g>r", "<cmd>GpRewrite<cr>", keymapOptions("Inline Rewrite"))
      vim.keymap.set({ "n", "i" }, "<C-g>a", "<cmd>GpAppend<cr>", keymapOptions("Append (after)"))
      vim.keymap.set({ "n", "i" }, "<C-g>b", "<cmd>GpPrepend<cr>", keymapOptions("Prepend (before)"))

      vim.keymap.set("v", "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions("Visual Rewrite"))
      vim.keymap.set("v", "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual Append (after)"))
      vim.keymap.set("v", "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", keymapOptions("Visual Prepend (before)"))
      vim.keymap.set("v", "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", keymapOptions("Implement selection"))

      vim.keymap.set({ "n", "i" }, "<C-g>gp", "<cmd>GpPopup<cr>", keymapOptions("Popup"))
      vim.keymap.set({ "n", "i" }, "<C-g>ge", "<cmd>GpEnew<cr>", keymapOptions("GpEnew"))
      vim.keymap.set({ "n", "i" }, "<C-g>gn", "<cmd>GpNew<cr>", keymapOptions("GpNew"))
      vim.keymap.set({ "n", "i" }, "<C-g>gv", "<cmd>GpVnew<cr>", keymapOptions("GpVnew"))
      vim.keymap.set({ "n", "i" }, "<C-g>gt", "<cmd>GpTabnew<cr>", keymapOptions("GpTabnew"))

      vim.keymap.set("v", "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", keymapOptions("Visual Popup"))
      vim.keymap.set("v", "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", keymapOptions("Visual GpEnew"))
      vim.keymap.set("v", "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", keymapOptions("Visual GpNew"))
      vim.keymap.set("v", "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", keymapOptions("Visual GpVnew"))
      vim.keymap.set("v", "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", keymapOptions("Visual GpTabnew"))

      vim.keymap.set({ "n", "i" }, "<C-g>x", "<cmd>GpContext<cr>", keymapOptions("Toggle Context"))
      vim.keymap.set("v", "<C-g>x", ":<C-u>'<,'>GpContext<cr>", keymapOptions("Visual Toggle Context"))

      vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>s", "<cmd>GpStop<cr>", keymapOptions("Stop"))
      vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>n", "<cmd>GpNextAgent<cr>", keymapOptions("Next Agent"))
    end,
  },
}
