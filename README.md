# saltstack-node-specific-pillar-states
Allows for dynamic node specific pillar data, derived from a nodes id, without explicitly specifying the nodename in `top.sls`. Furthermore allows to configure the states a node should have via pillar, making the state `top.sls` only contain information for the specific node thus preserving privacy of node identifiers (which would otherwise be shared with all nodes, due to state `top.sls` being shared with all nodes).

Usecase is all environments where you do not want one salt-minion to know the ids and statenames of the others.

## Examples
To configure e.g. the ssh state to be applied to node with id `myhost.example.com` create a file `$pillar_root/myhost.sls` with content:

```yaml
states:
  ssh:
```

This will result in a top.sls for the pillar looking like this:
```
# salt-run pillar.show_top
base:
    ----------
    *:
        - myhost
```

And the pillar items:
```
# salt-call pillar.items
local:
    ----------
    states:
        ----------
        ssh:
```

The top.sls for the states will then look like this:
```
# salt-call state.show_top
local:
    ----------
    base:
        - ssh
```

and provided you have a file `$file_root/ssh.sls` or `$file_root/ssh/init.sls` the state will be applied. Also the copy of the `$file_root` will only contain the content of the original `top.sls`, e.g.:
```jinja
base:
  '*':
  {% for state in pillar.get('states', {}).keys() %}
    - {{ state }}
  {% endfor %}
```
