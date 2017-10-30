function MovePathIntrinsicPosition(pathHandle, velocity)
    local dt=simGetSimulationTimeStep()
    local pos=simGetPathPosition(pathHandle)
    pos=pos+velocity*dt
    simSetPathPosition(pathHandle,pos) -- update the path's intrinsic position
end

function setJointsPositions_cb(msg)
    -- Copy robot joints subscriber callback
    for i=1,5,1 do
        simSetJointTargetPosition(New_joints_handle[i], msg.data[i])
    end

end

if (sim_call_type==sim_childscriptcall_initialization) then

    ik=simGetIkGroupHandle('ik')
    pathHandle=simGetObjectHandle('Path')
    target=simGetObjectHandle('Target')
    -- Get joints handles
    Joints_handle={-1,-1,-1,-1, -1}
    New_joints_handle={-1,-1,-1,-1, -1}
 
    for i=1,5,1 do
        Joints_handle[i]=simGetObjectHandle('joint'..(i)) -- robot arm
        New_joints_handle[i]=simGetObjectHandle('new_joint'..(i))
    end

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
        subscriber=simExtRosInterface_subscribe('/all_joint_position','std_msgs/Float32MultiArray','setJointsPositions_cb')
    end    
end


if (sim_call_type==sim_childscriptcall_actuation) then

    MovePathIntrinsicPosition(pathHandle, 0.05)
    simHandleIkGroup(ik)

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
    -- Following not really needed in a simulation script (i.e. automatically shut down at simulation end):
    if rosInterfacePresent then
        simExtRosInterface_shutdownPublisher(publisher)
        simExtRosInterface_shutdownSubscriber(subscriber)
    end
end

