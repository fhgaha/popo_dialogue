RSRC                 	   Resource            �+Y;�qx
   GraphData                                                   resource_local_to_scene    resource_name    script    value1 	   operator    value2    name    offset    size 	   variable    value    speaker_name    text    options    scroll_offset    connections    nodes 
   variables       Script D   res://addons/popochiu/editor/dialogue_graph/save_load/graph_data.gd ��������   Script M   res://addons/popochiu/editor/dialogue_graph/save_load/condition_node_data.gd ��������   Script I   res://addons/popochiu/editor/dialogue_graph/save_load/start_node_data.gd ��������   Script G   res://addons/popochiu/editor/dialogue_graph/save_load/set_node_data.gd ��������   Script L   res://addons/popochiu/editor/dialogue_graph/save_load/dialogue_node_data.gd ��������      local://Resource_osiy1 :         local://Resource_t3wbc �         local://Resource_yeqj1 $         local://Resource_5a26h �         local://Resource_a2sw5 G      0   res://game/dialogs/first/dialog_first_graph.res �      	   Resource                         first_time          ==          true          ConditionNode1    
   2���b��   
     #C  /C	   Resource                      
   StartNode    
    @)�  B   
           	   Resource                	         first_time          = 
                	   SetNode1    
     J�  \�   
     C  C	   Resource                         Main                          asdf                 DialogueNode1    
      �  ��   
     �C  pC	   Resource                         Main          asasa                exit2                 DialogueNode2    
     ��  ^C   
     �C  pC	   Resource             dialog_first_graph.res                 
    �<�  ��                  
   from_node ,   
   StartNode    
   from_port              to_node ,      ConditionNode1       to_port                 
   from_node ,   	   SetNode1    
   from_port              to_node ,      DialogueNode1       to_port                 
   from_node ,      ConditionNode1    
   from_port              to_node ,   	   SetNode1       to_port                 
   from_node ,      ConditionNode1    
   from_port             to_node ,      DialogueNode2       to_port                                                                              first_time             type             value       RSRC