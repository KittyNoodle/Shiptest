import { useBackend } from '../backend';
import { NoticeBox } from '../components';
import { Window } from '../layouts';
import { LaunchpadControl } from './LaunchpadConsole';

export const VioletPadRemote = (props, context) => {
  const { data } = useBackend(context);
  const { has_pad, pad_closed } = data;
  return (
    <Window
      title="Violetspace Interface Crystal"
      width={300}
      height={240}
      theme="abductor"
    >
      <Window.Content>
        {(!has_pad && <NoticeBox>No Launchpad Connected</NoticeBox>) || (
          <LaunchpadControl topLevel />
        )}
      </Window.Content>
    </Window>
  );
};
