require "../dsl_spec"

macro spec_for_main(spec_class_name, spec_desc, spec_cases, spec_dsl_lines = [] of StringLiteral, spec_class_define_lines = [] of StringLiteral, spec_sub_command_lines = [] of StringLiteral)
  {% for spec_case, index in spec_cases %}
    {% class_name = (spec_class_name.stringify + index.stringify).id %}

    # define dsl
    class {{class_name}} < Clim
      expand_lines({{spec_class_define_lines}})
      main do
        expand_lines({{spec_dsl_lines}})
        run do |opts, args|
          assert_opts_and_args({{spec_case}})
        end
        expand_lines({{spec_sub_command_lines}})
      end
    end

    # spec
    describe {{spec_desc}} do
      describe "if dsl is [" + {{spec_dsl_lines.join(", ")}} + "]," do
        describe "if argv is " + {{spec_case["argv"].stringify}} + "," do
          it_blocks({{class_name}}, {{spec_case}})
        end
      end
    end
  {% end %}
end

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Command Line Interface Tool.

                        Usage:

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec_for_main(
  spec_class_name: MainCommandOnly,
  spec_dsl_lines: [] of String,
  spec_desc: "main command,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "arg2"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["arg1", "arg2", "arg3"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1", "arg2", "arg3"],
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
      argv:              ["-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["--missing-option"],
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              ["-m", "arg1"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["arg1", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["-m", "-d"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Main command with desc.

                        Usage:

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec_for_main(
  spec_class_name: MainCommandWithDesc,
  spec_dsl_lines: [
    "desc \"Main command with desc.\"",
  ],
  spec_desc: "main command,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "arg2"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["arg1", "arg2", "arg3"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1", "arg2", "arg3"],
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
      argv:              ["-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["--missing-option"],
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              ["-m", "arg1"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["arg1", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["-m", "-d"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Main command with desc.

                        Usage:

                          main_command_of_clim_library [options] [arguments]

                        Options:

                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec_for_main(
  spec_class_name: MainCommandWithDescConst,
  spec_class_define_lines: [
    "DESC_CONST = \"Main command with desc.\"",
  ],
  spec_dsl_lines: [
    "desc DESC_CONST",
  ],
  spec_desc: "main command,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "arg2"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["arg1", "arg2", "arg3"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1", "arg2", "arg3"],
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
      argv:              ["-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["--missing-option"],
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              ["-m", "arg1"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["arg1", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["-m", "-d"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}
{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Main command with desc.

                        Usage:

                          main_command with usage [options] [arguments]

                        Options:

                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec_for_main(
  spec_class_name: MainCommandWithUsage,
  spec_dsl_lines: [
    "desc \"Main command with desc.\"",
    "usage \"main_command with usage [options] [arguments]\"",
  ],
  spec_desc: "main command,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "arg2"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["arg1", "arg2", "arg3"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1", "arg2", "arg3"],
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
      argv:              ["-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["--missing-option"],
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              ["-m", "arg1"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["arg1", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["-m", "-d"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Main command with desc.

                        Usage:

                          main_command with usage [options] [arguments]

                        Options:

                          --help                           Show this help.


                      HELP_MESSAGE
%}

spec_for_main(
  spec_class_name: MainCommandWithUsageConst,
  spec_class_define_lines: [
    "USAGE_CONST = \"main_command with usage [options] [arguments]\"",
  ],
  spec_dsl_lines: [
    "desc \"Main command with desc.\"",
    "usage USAGE_CONST",
  ],
  spec_desc: "main command,",
  spec_cases: [
    {
      argv:        [] of String,
      expect_help: {{main_help_message}},
      expect_args: [] of String,
    },
    {
      argv:        ["arg1"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1"],
    },
    {
      argv:        ["arg1", "arg2"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1", "arg2"],
    },
    {
      argv:        ["arg1", "arg2", "arg3"],
      expect_help: {{main_help_message}},
      expect_args: ["arg1", "arg2", "arg3"],
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
      argv:              ["-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["--missing-option"],
      exception_message: "Undefined option. \"--missing-option\"",
    },
    {
      argv:              ["-m", "arg1"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["arg1", "-m"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:              ["-m", "-d"],
      exception_message: "Undefined option. \"-m\"",
    },
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
  ]
)
{% end %}

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Main command with desc.

                        Usage:

                          main_command with usage [options] [arguments]

                        Options:

                          --help                           Show this help.
                          --version                        Show version.


                      HELP_MESSAGE
%}

spec_for_main(
  spec_class_name: MainCommandWithVersion,
  spec_dsl_lines: [
    "version \"Version 0.9.9\"",
    "desc \"Main command with desc.\"",
    "usage \"main_command with usage [options] [arguments]\"",
  ],
  spec_desc: "main command,",
  spec_cases: [
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:          ["--version"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:          ["--version", "arg"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:          ["arg", "--version"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:              ["-v"],
      exception_message: "Undefined option. \"-v\"",
    },
  ]
)
{% end %}

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Main command with desc.

                        Usage:

                          main_command with usage [options] [arguments]

                        Options:

                          --help                           Show this help.
                          --version                        Show version.


                      HELP_MESSAGE
%}

spec_for_main(
  spec_class_name: MainCommandWithVersionConst,
  spec_dsl_lines: [
    "version Clim::VERSION",
    "desc \"Main command with desc.\"",
    "usage \"main_command with usage [options] [arguments]\"",
  ],
  spec_desc: "main command,",
  spec_cases: [
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:          ["--version"],
      expect_output: Clim::VERSION + "\n",
    },
    {
      argv:          ["--version", "arg"],
      expect_output: Clim::VERSION + "\n",
    },
    {
      argv:          ["arg", "--version"],
      expect_output: Clim::VERSION + "\n",
    },
    {
      argv:              ["-v"],
      exception_message: "Undefined option. \"-v\"",
    },
  ]
)
{% end %}

{% begin %}
{%
  main_help_message = <<-HELP_MESSAGE

                        Main command with desc.

                        Usage:

                          main_command with usage [options] [arguments]

                        Options:

                          --help                           Show this help.
                          -v, --version                    Show version.


                      HELP_MESSAGE
%}

spec_for_main(
  spec_class_name: MainCommandWithVersionShort,
  spec_dsl_lines: [
    "version \"Version 0.9.9\", short: \"-v\"",
    "desc \"Main command with desc.\"",
    "usage \"main_command with usage [options] [arguments]\"",
  ],
  spec_desc: "main command,",
  spec_cases: [
    {
      argv:        ["--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["--help", "ignore-arg"],
      expect_help: {{main_help_message}},
    },
    {
      argv:        ["ignore-arg", "--help"],
      expect_help: {{main_help_message}},
    },
    {
      argv:          ["--version"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:          ["--version", "arg"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:          ["arg", "--version"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:          ["-v"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:          ["-v", "arg"],
      expect_output: "Version 0.9.9\n",
    },
    {
      argv:          ["arg", "-v"],
      expect_output: "Version 0.9.9\n",
    },
  ]
)
{% end %}
