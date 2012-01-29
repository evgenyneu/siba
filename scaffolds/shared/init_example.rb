        # The backup is started after all plugins are initialized
        # Therefore, this is a good place to do some checking (access, shell commands etc.)
        # to make sure everything works before backup is started

        # Examples:
        #
        # Load and validate options
        key = Siba::SibaCheck.options_string options, "key"
        key2 = Siba::SibaCheck.options_string options, "missing", true, "default value"
        array = Siba::SibaCheck.options_string_array options, "array"
        bool = Siba::SibaCheck.options_bool options, "bool"
        Siba.settings # Gets the global app settings (value of "settings" key in YAML file)
        raise Siba::Error, "Something wrong" if false
