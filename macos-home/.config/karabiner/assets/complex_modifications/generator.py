template = '''
    {{
      "description": "{key} to {mod}, {key} if alone, repeat if double tapped",
      "manipulators": [
        {{
          "conditions": [
            {{
              "type": "variable_if",
              "name": "double_{key}",
              "value": 1
            }},
            {{
              "type": "device_if",
              "identifiers": [
                {{
                  "vendor_id": 1452,
                  "product_id": 832,
                  "description": "Built in Apple Keyboard"
                }}
              ]
            }}
          ],
          "from": {{
            "key_code": "{key}",
            "modifiers": {{
              "optional": [
                "any"
              ]
            }}
          }},
          "to": [
            {{
              "key_code": "{key}"
            }}
          ],
          "to_after_key_up": [
            {{
              "set_variable": {{
                "name": "double_{key}",
                "value": 0
              }}
            }}
          ],
          "type": "basic"
        }},
        {{
          "conditions": [
            {{
              "type": "device_if",
              "identifiers": [
                {{
                  "vendor_id": 1452,
                  "product_id": 832,
                  "description": "Built in Apple Keyboard"
                }}
              ]
            }}
          ],
          "from": {{
            "key_code": "{key}",
            "modifiers": {{
              "optional": [
                "any"
              ]
            }}
          }},
          "to_after_key_up": [
            {{
              "key_code": "{key}"
            }}
          ],
          "to_if_held_down": [
            {{
              "set_variable": {{
                "name": "double_{key}",
                "value": 0
              }}
            }},
            {{
              "key_code": "{mod}",
              "halt": true
            }}
          ],
          "to": [
            {{
              "set_variable": {{
                "name": "double_{key}",
                "value": 1
              }}
            }},
            {{
              "key_code": "{mod}"
            }}
          ],
          "to_delayed_action": {{
            "to_if_invoked": [
              {{
                "set_variable": {{
                  "name": "double_{key}",
                  "value": 0
                }}
              }}
            ],
            "to_if_canceled": [
              {{
                "set_variable": {{
                  "name": "double_{key}",
                  "value": 0
                }}
              }}
            ]
          }},
          "type": "basic"
        }}
      ]
    }},
'''

# maps = {
#         "a": "left_shift",
#         "s": "left_command",
#         "d": "left_option",
#         "f": "left_control",
#         "j": "right_control",
#         "k": "right_option",
#         "l": "right_command",
#         "semicolon": "right_shift",
#         }

maps = {
        "z": "left_option",
        "x": "left_command",
        "c": "left_control",
        "comma": "right_control",
        "period": "right_command",
        "slash": "right_option",
        }

for k, mod in maps.items():
    val = template.format(key=k, mod=mod)
    print(val)
