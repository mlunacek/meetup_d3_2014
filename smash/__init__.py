from smash_base import *

def initialize():
    '''
    Load method copied and modified from https://github.com/wrobstory/vincent
    '''
    from IPython.core.display import display, Javascript
    require_js = '''
        if (window.d3 === undefined){{   
            require.config({{ paths: {{d3: "http://d3js.org/d3.v3.min"}} }});
            require(['d3'], function(d3) {{
                window.d3 = d3;
                console.log(window.d3);
            }});
        }};
    '''
    display(Javascript(require_js.format()))


