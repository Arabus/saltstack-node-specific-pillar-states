{% set nodename = salt['grains.get']('id').split('.')[0] %}
base:
  '*':
    - {{ nodename }}
