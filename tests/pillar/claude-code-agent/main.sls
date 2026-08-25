claude-code-agent:
  lookup:
    {%- if grains.os_family == "RedHat" %}
    config:
      managed-settings.json: |-
        {
            "parentSettingsBehavior": "merge"
        }
    install_method: rpm
    {%- elif grains.os_family == "Windows" %}
    {%- endif %}
