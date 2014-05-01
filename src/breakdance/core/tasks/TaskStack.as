package breakdance.core.tasks {

    import flash.events.EventDispatcher;

    /**
     * ...
     * @author Alexey Stashin
     */
    public class TaskStack extends EventDispatcher {
        private var _tasks:Vector.<BaseTask>;
        private var _currentTask:BaseTask;

        private var _totalTasks:int = 0;

        public function TaskStack () {
            init ();
        }

        public function destroy ():void {
            if (_currentTask) {
                _currentTask.destroy ();
                _currentTask = null;
            }

            for each(var task:BaseTask in _tasks)
                task.destroy ();
            _tasks = null;
        }

        public function addTask (task:BaseTask):void {
            _tasks.push (task);
        }

        public function start ():void {
            _totalTasks = _tasks.length;
            startNextTask ();
        }

        // private

        private function init ():void {
            _tasks = new Vector.<BaseTask> ();
        }

        private function startNextTask ():void {
            if (_currentTask)
                return;

            if (_tasks.length == 0) {
                dispatchEvent (new TaskEvent (TaskEvent.TASK_COMPLETE));
                return;
            }

            _currentTask = _tasks.shift ();
            _currentTask.addEventListener (TaskEvent.TASK_COMPLETE, onTaskComplete);
            _currentTask.addEventListener (TaskEvent.TASK_ERROR, onTaskError);
            _currentTask.addEventListener (TaskEvent.TASK_PROGRESS, onTaskProgress);
            _currentTask.start ();
        }

        private function onTaskComplete (e:TaskEvent):void {
            var ratio:Number = (_totalTasks - _tasks.length) / _totalTasks;
            dispatchEvent (new TaskEvent (TaskEvent.TASK_PROGRESS, e.message, ratio));

            _currentTask.destroy ();
            _currentTask = null;
            startNextTask ();
        }

        private function onTaskError (e:TaskEvent):void {
            dispatchEvent (e.clone ());
        }

        private function onTaskProgress (e:TaskEvent):void {
            var ratio:Number = (_totalTasks - _tasks.length - 1) / _totalTasks + e.ratio / _totalTasks;
            dispatchEvent (new TaskEvent (TaskEvent.TASK_PROGRESS, '', ratio));
        }

    }

}