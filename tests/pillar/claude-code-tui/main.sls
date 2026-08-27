claude-code-tui:
  lookup:
    config:
      managed-settings.json: |-
        {
            "parentSettingsBehavior": "merge"
        }
    {%- if grains.os_family == "RedHat" %}
    install_method: rpm
    {%- elif grains.os_family == "Windows" %}
    install_method: npm
    {%- endif %}
