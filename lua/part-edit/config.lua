local Config = {}

function Config:new(config)
	local instance = {
		_config = config,
	}

	setmetatable(instance, {
		__index = Config,
	})

	return instance
end

function Config:set(config)
	self._config = vim.tbl_deep_extend("force", self._config, config)
end

function Config:get()
	return self._config
end

local default_config = {
	save_original_file = true,
}

return Config:new(default_config)
