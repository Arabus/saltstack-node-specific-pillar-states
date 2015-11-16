base:
  '*':
{% for state in pillar.get('states', {}).keys() %}
    - {{ state }}
{% endfor %}
