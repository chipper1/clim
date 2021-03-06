require "../dsl_spec"

macro spec_for_alias_name(spec_class_name, spec_cases)
  {% for spec_case, index in spec_cases %}
    {% class_name = (spec_class_name.stringify + index.stringify).id %}

    # define dsl
    class {{class_name}} < Clim
      main_command do
        run do |opts, args|
          assert_opts_and_args({{spec_case}})
        end
        sub_command "sub_command_1" do
          alias_name "alias_sub_command_1"
          option "-a ARG", "--array=ARG", desc: "Option test.", type: Array(String), default: ["default string"]
          run do |opts, args|
            assert_opts_and_args({{spec_case}})
          end
          sub_command "sub_sub_command_1" do
            option "-b", "--bool", type: Bool, desc: "Bool test."
            run do |opts, args|
              assert_opts_and_args({{spec_case}})
            end
          end
        end
        sub_command "sub_command_2" do
          alias_name "alias_sub_command_2", "alias_sub_command_2_second"
          run do |opts, args|
            assert_opts_and_args({{spec_case}})
          end
        end
      end
    end

    # spec
    describe "alias name case," do
      describe "if argv is " + {{spec_case["argv"].stringify}} + "," do
        it_blocks({{class_name}}, {{spec_case}})
      end
    end
  {% end %}
end
