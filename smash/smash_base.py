#!/usr/bin/env python
from IPython.core.display import display, HTML
import os
import random
import jinja2 as jin

templateLoader = jin.FileSystemLoader( searchpath=os.path.dirname(os.path.abspath(__file__)) )
templateEnv = jin.Environment( loader=templateLoader )


class SmashBase:

	def __init__(self, **params):
		self.height = params.get('height', 300)
		self.width = params.get('width', 800)
		self.iframe = params.get('iframe', False) # Create an tmp html file and serve in iframe
		self._set_template_path()
		self.id = random.randint(0, 2**16) # Unique id (from vincent.py)
		self.filename = params.get('name', None)
		self.data = params.get('data', None)
		self.d3_lib = "http://d3js.org/d3.v3.min.js"
		self.default_vars = {'id': self.id, 
						     'height': self.height, 
						     'width': self.width,
						     'extend': self.iframe,
						     'd3lib': self.d3_lib }

	def show(self):
		#print 'show'
		output = self._template() 
		if self.iframe:
			self._show_iframe(output)
		else:
			self._show_static(output)

	def create(self):
		self.default_vars['extend'] = True
		output = self._template()
		self._show_iframe(output)

	def _show_static(self, output):
		return display(HTML(output))

	def _show_iframe(self, output):
		filename = 'smash_' + self.name + '_' + str(self.id)+'.html'
		if self.filename:
			filename = 'smash_' + self.filename + '_.html'
			
		with open(filename,'w') as outfile:
			outfile.write(output.decode('utf-8'))
 		return display(self._create_iframe())

 	def _template(self):
		template = self.templateEnv.get_template( self.name + '.tpl' )
		output = template.render( self.default_vars )
		return output

 	def _create_iframe(self):
 		a = HTML('<iframe src="files/{0}" width={1} height={2}></iframe>'.format(self.filename, self.width, self.height))
 		return a

	def _set_template_path(self):
		packdir = os.path.dirname(os.path.abspath(__file__))
		templateLoader = jin.FileSystemLoader( searchpath=os.path.join(packdir,'templates'))
		self.templateEnv = jin.Environment( loader=templateLoader )

	def _clean_data(self):
		# This will do for now.
		self.data = self.data.dropna()
		self.data = self.data._get_numeric_data()

# A few examples...


class collide(SmashBase):
		
	def __init__(self, **params):
		SmashBase.__init__(self, **params)
		self.name = 'collide'

class scatter(SmashBase):

	def __init__(self, **params):
		SmashBase.__init__(self, **params)
		self.name = 'scatter'

 	def _template(self):
 		self.data = self.data.dropna()
		template = self.templateEnv.get_template( self.name + '.tpl' )
		self.default_vars['x'] = self.data.columns.values[0]
		self.default_vars['y'] = self.data.columns.values[1]
		self.default_vars['color'] = self.data.columns.values[2]
		self.default_vars['data'] = self.data.to_json(orient='records')
		output = template.render( self.default_vars )
		return output

class parallel(SmashBase):

	def __init__(self, **params):
		SmashBase.__init__(self, **params)
		self.name = 'parallel'

	def _template(self):
		self._clean_data()
		template = self.templateEnv.get_template( self.name + '.tpl' )
		self.default_vars['data'] = self.data.to_json(orient='records')
		output = template.render( self.default_vars )
		return output




