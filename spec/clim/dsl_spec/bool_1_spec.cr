require "../dsl_spec"

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          -b, --bool                       Option description. [type:Bool]
                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec(
  spec_class_name: MainCommandWithBool,
  spec_dsl_lines: [
    "option \"-b\", \"--bool\", type: Bool",
  ],
  spec_desc: "main command with Bool option,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool,
        "method" => "bool",
        "expect_value" => false,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["-b"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["--bool"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: [] of String,
    },
    {
      argv:        ["-b", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["--bool", "arg1"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "-b"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "--bool"],
      expect_help: {{main_help_message}},
      expect_opts: {
        "type" => Bool,
        "method" => "bool",
        "expect_value" => true,
      },
      expect_args: ["arg1"],
    },
    {
      argv:              ["-h"],
      exception_message: "Undefined option. \"-h\"",
    },
    {
      argv:              ["--help", "-ignore-option"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["-ignore-option", "--help"],
      exception_message: "Undefined option. \"-ignore-option\"",
    },
    {
      argv:              ["--b"],
      exception_message: "Undefined option. \"--b\"",
    },
    {
      argv:              ["-bool"],
      exception_message: "Undefined option. \"-bool\"",
    },
    {
      argv: ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv: ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv: ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}