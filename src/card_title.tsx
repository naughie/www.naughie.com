type Props = {
  children: string;
};

const CardTitle = ({ children }: Props) => {
  return <div class="card-title pb-3">{children}</div>;
};
export type CardTitle = typeof CardTitle;

export default CardTitle;
