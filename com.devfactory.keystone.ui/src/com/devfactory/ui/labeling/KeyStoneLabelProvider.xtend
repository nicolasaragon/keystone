/*
* generated by Xtext
*/
package com.devfactory.ui.labeling

import com.google.inject.Inject
import com.devfactory.keyStone.Expression
import com.devfactory.keyStone.SearchSettings
import com.devfactory.keyStone.MouseActionParams
import com.devfactory.keyStone.KeyboardActionParams
import com.devfactory.keyStone.WaitActionParams
import com.devfactory.keyStone.KeyboardChord
import com.devfactory.keyStone.DragActionParams
import com.devfactory.keyStone.BrowseToActionParams
import com.devfactory.keyStone.Action
import com.devfactory.keyStone.PauseActionParams
import com.devfactory.keyStone.Step
import com.devfactory.keyStone.KeyValuePair
import com.devfactory.keyStone.Assertion
import com.devfactory.keyStone.Assignment
import com.devfactory.keyStone.DataDrivenStep

/**
 * Provides labels for a EObjects.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#labelProvider
 */
class KeyStoneLabelProvider extends org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider {

	@Inject
	new(org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}

	// Labels and icons can be computed like this:
	
//	def text(Greeting ele) {
//		'A greeting to ' + ele.name
//	}
//
//	def image(Greeting ele) {
//		'Greeting.gif'
//	}
	def text(Expression ele){
		var tag = ''
		if(ele.op != null){
			if(ele.left != null)
				tag += text(ele.left as Expression)
			if(ele.op != null && ele.op != "(")
				tag += switch(ele.op){ case '.': '.' case 'of': ' of '}
			if(ele.right != null)
				tag += text(ele.right as Expression)
			if(ele.op == "(")
				tag += "(" + ele.arguments.map[ text ].join(",") + ")"
			if(ele.op == "[")
				if ((ele as SearchSettings).index != null && (ele as SearchSettings).properties != null && (ele as SearchSettings).expected != null)
					tag = '''«IF (ele as SearchSettings).index.value == "0"»first«ELSEIF (ele as SearchSettings).index.value == "1"»2nd«ELSEIF (ele as SearchSettings).index.value == "2"»3rd«ELSE»«Integer::parseInt((ele as SearchSettings).index.value).intValue + 1»th«ENDIF» child node having[«(ele as SearchSettings).properties.map['''"«value»"'''].join(",")»]=[«(ele as SearchSettings).expected.map[it.text].join(",")»]'''.toString
				else
					tag = 'incomplete find expression'
			
		}
		else {
			tag += ele.value?:""
		}
		return tag
	}
	def text(Assignment ele){
		val varName = (if(ele.variableName!=null) '''«text(ele.variableName as Expression)»''' else '''''')
		val assignedValue = (if(ele.assignedValue!=null) '''«text(ele.assignedValue as Expression)»''' else '''''')
		("set " + varName + " to " + assignedValue)
		
	}
	def text(MouseActionParams ele){
		'''<«ele.x.text»,«ele.y.text»>«IF ele.chord != null» «text(ele.chord)»«ENDIF»'''
	}
	def text(KeyboardActionParams ele){
		'''“«IF ele.text != null»«ele.text.text»«ENDIF»”'''
	}
	def text(WaitActionParams ele){
		'''for «ele.delayTime»ms'''
	}
	def text(KeyboardChord ele){
		ele.keys.join("+")
	}
	def text(DragActionParams ele){
		if(ele.target!=null)
			text(ele.target)
		else
			'''screen coordinates <«ele.x»,«ele.y»>'''
	}
	def text(BrowseToActionParams ele){
		'''url=«text(ele.url)»'''
	}
	def text(Action ele){
		var tag = ''
		tag += (ele.name?:"") + " "
		if(ele.actionParams != null){
			if(ele.actionParams instanceof MouseActionParams)
				tag += text(ele.actionParams as MouseActionParams)
			else if (ele.actionParams instanceof WaitActionParams)
				tag += text(ele.actionParams as WaitActionParams)
			else if (ele.actionParams instanceof KeyboardActionParams)
				tag += text(ele.actionParams as KeyboardActionParams)
			else if (ele.actionParams instanceof PauseActionParams)
				tag += (if(ele.actionParams!=null) (ele.actionParams as PauseActionParams).timePaused else "")
			else if (ele.actionParams instanceof DragActionParams)
				tag += text(ele.actionParams as DragActionParams)
			else if (ele.actionParams instanceof BrowseToActionParams)
				tag += text(ele.actionParams as BrowseToActionParams)
		}
		tag
	}
	def text(DataDrivenStep step){
		('on every ' + step.columnNames.map[text].join(',') + ' from ' + step.dataSource.text)
	}
	def text(Step ele){
		('tell ' + (if(ele.context!=null) text(ele.context)))
	}
	def text(KeyValuePair ele){
		if(ele.left!=null){
			(text(ele.left as KeyValuePair) + " and " + text(ele.right as KeyValuePair)) 
		}else{
			(text(ele.property as Expression) + " equals " + (if(ele.value!=null) ele.value.value?:""))
		}
	}
	def text(Assertion ele){
		if(ele.filter!=null){
			return ('assert ' + text(ele.filter as KeyValuePair))	
		}
		if(ele.child != null){
			return ('assert '+text(ele.child))
		}
		""
	}
}
