-- DO NOT WRITE CODE OUTSIDE OF THE if-then-end SECTIONS BELOW!! (unless the code is a function definition)

function createRobotUI()
	-- Create the custom UI for climbing up the poll:
	xml= '<ui title="Control Panel" closeable="false" resizeable="false" activate="false" size="350,0">'..[[
		<group>
            <label style="* {font-size: 20px;}" text="Robot"/>
            <group layout="vbox">
                <label text="Joint_5: 0" style="* {qproperty-alignment: AlignCenter}" id="2"/>
                <hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="20"/>
            </group>
			<group layout="vbox">
				<label text="Joint_4: 0" style="* {qproperty-alignment: AlignCenter}" id="3"/>
                <hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="21"/>
            </group>
			<group layout="vbox">
				<label text="Joint_3: 0" style="* {qproperty-alignment: AlignCenter}" id="4"/>
                <hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="22"/>
            </group>
			<group layout="vbox">
				<label text="Joint_2: 0" style="* {qproperty-alignment: AlignCenter}" id="5"/>
                <hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="23"/>
            </group>
			<group layout="vbox">
				<label text="Joint_1: 0" style="* {qproperty-alignment: AlignCenter}" id="6"/>
                <hslider style="* {min-width: 200px; margin-top: 10px}" minimum="-90" maximum="90" onchange="sliderChange" id="24"/>
            </group>
			<button text="ALL JOINTS RESET" style="* {margin-left: 70px; margin-right: 70px; margin-top: 20px; padding: 10px}" onclick="buttonClick" id="101"/>
		</group>
        </ui>
        ]]
	
	return xml
end

function sliderChange(ui,id, newVal)
    -- Speed Slider of Roll UI
	if(id == 20) then
        simSetJointTargetPosition(Joints_handle[5], newVal/180*math.pi)
        simExtCustomUI_setLabelText(robot_ui, 2, "Joint 5: " .. tostring(newVal))
	end
	if(id == 21) then
        simSetJointTargetPosition(Joints_handle[4], newVal/180*math.pi)
        simExtCustomUI_setLabelText(robot_ui, 3, "Joint 4: " .. tostring(newVal))
	end
	if(id == 22) then
        simSetJointTargetPosition(Joints_handle[3], newVal/180*math.pi)
        simExtCustomUI_setLabelText(robot_ui, 4, "Joint 3: " .. tostring(newVal))
	end
	if(id == 23) then
        simSetJointTargetPosition(Joints_handle[2], newVal/180*math.pi)
        simExtCustomUI_setLabelText(robot_ui, 5, "Joint 2: " .. tostring(newVal))
	end
	if(id == 24) then
        simSetJointTargetPosition(Joints_handle[1], newVal/180*math.pi)
        simExtCustomUI_setLabelText(robot_ui, 6, "Joint 1: " .. tostring(newVal))
	end
end

function buttonClick(ui,id)
	if(id == 101) then
        simSetJointTargetPosition(Joints_handle[5], 0)
        simExtCustomUI_setSliderValue(robot_ui, 20, 0)
        simExtCustomUI_setLabelText(robot_ui, 2, "Joint 5: " .. tostring("0"))
        simSetJointTargetPosition(Joints_handle[4], 0)
        simExtCustomUI_setSliderValue(robot_ui, 21, 0)
        simExtCustomUI_setLabelText(robot_ui, 3, "Joint 4: " .. tostring("0"))
        simSetJointTargetPosition(Joints_handle[3], 0)
        simExtCustomUI_setSliderValue(robot_ui, 22, 0)
        simExtCustomUI_setLabelText(robot_ui, 4, "Joint 3: " .. tostring("0"))
        simSetJointTargetPosition(Joints_handle[2], 0)
        simExtCustomUI_setSliderValue(robot_ui, 23, 0)
        simExtCustomUI_setLabelText(robot_ui, 5, "Joint 2: " .. tostring("0"))
        simSetJointTargetPosition(Joints_handle[1], 0)
        simExtCustomUI_setSliderValue(robot_ui, 24, 0)
        simExtCustomUI_setLabelText(robot_ui, 6, "Joint 1: " .. tostring("0"))
	end
end

if (sim_call_type==sim_childscriptcall_initialization) then

    robot_ui = simExtCustomUI_create(createRobotUI()) -- creat User Interface

    Joints_handle={-1,-1,-1,-1,-1} -- get object handle of joints
    for i=1,5,1 do
        Joints_handle[i]=simGetObjectHandle('joint'..i)
    end

    action = 0 -- for different action choice

    -- Check if the required RosInterface is there:
    moduleName=0
    index=0
    rosInterfacePresent=false
    while moduleName do
        moduleName=simGetModuleName(index)
        if (moduleName=='RosInterface') then
            rosInterfacePresent=true
        end
        index=index+1
    end

    -- Prepare the float32 publisher and subscriber (we subscribe to the topic we advertise):
    if rosInterfacePresent then
        publisher=simExtRosInterface_advertise('/all_joint_position','std_msgs/Float32MultiArray')
        --subscriber=simExtRosInterface_subscribe('/all_joint_position','std_msgs/Float32MultiArray','setJointsPositions_cb')
    end  

end


if (sim_call_type==sim_childscriptcall_actuation) then
    
    if (action == 0) then
        
    end

    joint_position = {0, 0, 0, 0, 0}
    -- get current position
    for i=1,5,1 do
        joint_position[i] = simGetJointPosition(Joints_handle[i])
    end
    -- publish joint positions
    if rosInterfacePresent then
        simExtRosInterface_publish(publisher,{data=joint_position})
    end 

end


if (sim_call_type==sim_childscriptcall_sensing) then

    -- Put your main SENSING code here

end


if (sim_call_type==sim_childscriptcall_cleanup) then

    -- Put some restoration code here

end

